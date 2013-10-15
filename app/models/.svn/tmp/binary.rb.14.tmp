# == Schema Information
# Schema version: 11
#
# Table name: binaries
#
#  id           :integer(11)     not null, primary key
#  title        :string(255)
#  content_type :string(255)
#  filename     :string(255)
#  size         :integer(11)
#

class Binary < ActiveRecord::Base
  WATERMARK_FILE = File.join(RAILS_ROOT, 'public/images/watermark_logo.png').freeze

  attr_accessor :need_watermark

  has_attachment :content_type => ['application/octet-stream', :image],
    :storage => :file_system,
    :path_prefix => "public/images/binary",
    #:max_size => 200.kilobytes,
    :resize_to => '500x',
    :processor => :Rmagick

  validates_as_attachment

  after_attachment_saved do |record|
    if record.need_watermark
      image_file = File.join(RAILS_ROOT, 'public', record.public_filename)
      Binary.water_mark image_file, WATERMARK_FILE
    end
  end

  def self.water_mark(full_path, watermark_path)
    water_mark_state full_path, watermark_path, 1
  end

  # 可以控制位置的水印方法
  def self.water_mark_state(full_path, watermark_path, state)
    if File.exists?(full_path) && File.exists?(watermark_path)
      dst = Magick::ImageList.new(full_path).first 
      src = Magick::Image.read(watermark_path).first 

      gravity =
        case state.to_i
        when 1 then Magick::SouthWestGravity #左下角
        when 2 then Magick::NorthWestGravity #左上角 
        when 3 then Magick::SouthEastGravity #右下角 
        when 4 then Magick::NorthEastGravity #右上角 
        when 5 then Magick::CenterGravity #中间
        else Magick::SouthWestGravity #默认左下角
        end

      dst.composite(src, gravity, Magick::OverCompositeOp).write(full_path)
    end
  rescue
    HoptoadNotifier.notify($!)
  end

  def self.manual_water_mark image_path, logo_path, width, height, left, top
    image = Magick::ImageList.new(image_path).first
    logo  = Magick::Image.read(logo_path).first.resize(width, height)

    image.composite(logo, left, top, Magick::OverCompositeOp).write(image_path)
  rescue
    HoptoadNotifier.notify($!)
  end
end


