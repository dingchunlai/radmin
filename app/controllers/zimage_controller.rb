class ZimageController < ApplicationController
  def upload
    shuiyin = params[:shuiyin]
    Zimage.attachment_options.merge! :resize_to => params[:photo_type] unless params[:photo_type].blank?
    if shuiyin.to_s=="1"
      water = "images/watermark_logo.png"
    elsif shuiyin.to_s=="2"
      water = "images/watermark_logo_b.gif"
    else
      water = "images/watermark_logo.png"
    end
    @insertString=""
    for i in [1,2,3,4,5]
      file_title = params["zimage#{i}"]["uploaded_data"].original_filename
      t = Time.now
      file_suffix = file_title[/(\.\w+)$/,1]
      file_name = "#{Digest::MD5.hexdigest(rand(1000).to_s + '-' + t.to_i.to_s)}#{file_suffix}"
      zimage = Zimage.create((params["zimage#{i}"].merge!(:filename => file_name)))
      @insertString += "<p><img src=\"#{zimage.public_filename}\" /></p>"
      full_path = File.join(RAILS_ROOT, 'public/', zimage.public_filename)
      watermark_path = File.join(RAILS_ROOT, 'public/', "#{water}")
      Zimage.water_mark full_path, watermark_path
    end
    render :layout => false
  end
end
