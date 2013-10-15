class BinariesController < ApplicationController

  def upload
    logger.info("aaa")
    logger.info(params[:binary])
    logger.info("aaa")
    logger.info(params[:binary][:uploaded_data].original_filename)
    logger.info("aaa")    
    logger.info(params[:dont_watermark])
    logger.info("aaa")
    
    
    Binary.attachment_options.merge! :resize_to => params[:photo_type] unless params[:photo_type].blank?
    file_title = params[:binary][:uploaded_data].original_filename
    t = Time.now
    file_suffix = file_title[/(\.\w+)$/,1]
    file_name = "#{Digest::MD5.hexdigest(rand(1000).to_s + '-' + t.to_i.to_s)}#{file_suffix}"
    binary = Binary.create((params[:binary].merge!(:filename => file_name, :need_watermark => params[:dont_watermark] ? nil : true)))
    @insertString = "<img src=\"#{binary.public_filename}\" />"
    render :layout => false
  end
 
  def member_upload
    file = params[:binary][:uploaded_data]
    title = params[:binary][:title]
    save_path = "/uploads/member_upload/"
    @insertString = "<img src=\"#{save_path + get_file(file, save_path)}\" alt=\"#{title}\" />"
#    puts save_path + get_file(file, save_path)
#    session[:backitem] = save_path + get_file(file, save_path)
#    s = session[:backitem]
#    puts "======================11111"
#    puts s
#    puts @insertString
#    puts "======================11111111111"
#    logger.info("==================")
#    logger.info(s)
#    logger.info("==================")
    render :layout => false
  end


  def flex_upload

    # file = params[:Filedata].read
    Binary.attachment_options.merge! :resize_to => params[:photo_type] unless params[:photo_type].blank?
    file_title = params[:Filename]

    t = Time.now
    file_suffix = file_title[/(\.\w+)$/,1]
    file_name = "#{Digest::MD5.hexdigest(rand(1000).to_s + '-' + t.to_i.to_s)}#{file_suffix}"

    binary = {:uploaded_data => params[:Filedata], :title => file_title, :filename => file_name, :need_watermark => params[:dont_watermark] ? nil : true}
    binary = Binary.create(binary)
    @insertString = "<p><img src=\"#{binary.public_filename}\" /></p>"
    render :text => @insertString
  end
end
