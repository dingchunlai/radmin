class Zimage < ActiveRecord::Base
  has_attachment :content_type => ['application/octet-stream', :image],
  :storage => :file_system,
  :path_prefix => "public/images/binary",
  :max_size => 500.kilobytes,
  :resize_to => '700x500>',
  :processor => :Rmagick
  def self.water_mark full_path, watermark_path
    if File.exists?(full_path) && File.exists?(watermark_path)
      begin
        dst = Magick::ImageList.new(full_path).first
        src = Magick::Image.read(watermark_path).first
        result = dst.composite(src, Magick::SouthWestGravity, Magick::OverCompositeOp)
        result.write(full_path)
      rescue Magick::ImageMagickError
        puts "--------------------"
        puts "#{$0}: ImageMagickError - #{$!}"
      rescue => e
      puts "++++++++++++++++++++ error ++++"
      puts e
      end
    end
  end
  validates_as_attachment
  private
  def full_filename(thumbnail = nil)
    file_system_path = (thumbnail ? thumbnail_class : self).attachment_options[:path_prefix].to_s
    custom_path = Time.now.strftime("%Y%m%d").to_s
    File.join(RAILS_ROOT, file_system_path, custom_path, thumbnail_name_for(thumbnail))
  end

  def uploaded_data=(file_data)
    super
    now = Time.now
    self.filename = 'img'+now.strftime("%Y%m%d").to_s+now.to_i.to_s+File.extname(file_data.original_filename)
  end
end
