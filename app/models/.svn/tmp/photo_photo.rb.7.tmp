# == Schema Information
# Schema version: 11
#
# Table name: photo_photos
#
#  id            :integer(11)     not null, primary key
#  user_id       :integer(11)
#  ip            :string(255)
#  album_id      :integer(11)
#  parent_id     :integer(11)
#  content_type  :string(255)
#  filename      :string(255)
#  thumbnail     :string(255)
#  size          :integer(11)
#  width         :integer(11)
#  height        :integer(11)
#  is_valid      :boolean(1)      not null
#  name          :string(255)
#  description   :string(255)
#  filepath      :string(255)
#  is_cover      :boolean(1)      not null
#  is_delete     :boolean(1)      not null
#  view_count    :integer(11)     default(1), not null
#  reply_count   :integer(11)     default(0), not null
#  type_id       :integer(11)
#  created_at    :datetime
#  updated_at    :datetime
#  slide         :integer(11)
#  case_id       :integer(19)
#  flow_status   :string(510)
#  deco_image_id :integer(11)
#  entity_id     :integer(11)
#

class PhotoPhoto < ActiveRecord::Base
  has_attachment :storage => :file_system,
    :path_prefix => "public/files/hekea/case_img/",
    :size => 1.kilobyte..2.megabytes,
    :resize_to => '1000x750>',
    :thumbnails=>{:s => '160x120>'},
    :content_type => ['image'],
    :processor => :Rmagick
    
  after_attachment_saved do |record|
    if record.thumbnail.nil?
      # Don't add watermarks to thumbnails
      begin
        full_path = File.join(RAILS_ROOT, 'public/', record.public_filename)
        watermark_path = File.join(RAILS_ROOT, 'public/', 'images/watermark_logo.png')
        if File.exists?(full_path) && File.exists?(watermark_path)
          dst = Magick::ImageList.new(full_path).first
          src = Magick::Image.read(watermark_path).first
          result = dst.composite(src, Magick::SouthWestGravity, Magick::OverCompositeOp)
          result.write(full_path)
        end
      rescue

      end
      
    end
  end

  def get_photo_url
    path_prefix = type_id == 5 ? "http://image.51hejia.com" : "http://image.51hejia.com/files/hekea/case_img/"
    path_prefix << filepath
  end
  private
  def full_filename(thumbnail = nil)
    file_system_path = (thumbnail ? thumbnail_class : self).attachment_options[:path_prefix].to_s
    custom_path = Time.now.strftime("%Y%m%d").to_s
    thumbnail_path = custom_path + "/" + "tn"+"/"
    original_path = custom_path + "/" 
    case self.thumbnail
    when "s"
      File.join(RAILS_ROOT, file_system_path, thumbnail_path, thumbnail_name_for(thumbnail))
    when "m"
      File.join(RAILS_ROOT, file_system_path, thumbnail_path, thumbnail_name_for(thumbnail))
    else
      File.join(RAILS_ROOT, file_system_path, original_path, thumbnail_name_for(thumbnail))
    end
  end

  def uploaded_data=(file_data)
    super
    now = Time.now
    if $rd.nil?
      $rd = 0
    else
      $rd += 1
    end
    str_now = now.to_i.to_s
    str_now = left(str_now, str_now.length-1)

    self.filename = 'img'+now.strftime("%Y%m%d").to_s + str_now + $rd.to_s + File.extname(file_data.original_filename) if respond_to?(:filename)
    
    #    self.filename = "#{Digest::SHA1.hexdigest(Time.now.to_s)}#{File.extname(file_data.original_filename)}" if respond_to?(:filename)
  end
  
end
