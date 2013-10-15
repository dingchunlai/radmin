# -*- coding: utf-8 -*-
# == Schema Information
# Schema version: 11
#
# Table name: article_images
#
#  id           :integer(11)     not null, primary key
#  product_id   :integer(11)
#  parent_id    :integer(11)
#  title        :string(255)
#  filename     :string(255)
#  content_type :string(255)
#  thumbnail    :string(255)
#  size         :integer(11)
#  width        :integer(11)
#  height       :integer(11)
#  is_primary   :boolean(1)
#  createdate   :timestamp
#

class ArticleImage < ActiveRecord::Base
  belongs_to :brand,
  :class_name => "Article",
  :foreign_key => "article_id"

  has_attachment :content_type => :image,
  :storage => :file_system,
  :path_prefix => "public/files/hekea/article_img/sourceImage",
  # :size => 1.kilobytes .. 2.megabytes,
  :max_size => 500.kilobyte,
  :resize_to => '500x375>',
  :thumbnails => { :thumb => '120x90>', :medium => '160x120>'},
  :processor => :Rmagick
 after_attachment_saved do |record|
    # Don't add watermarks to thumbnails
    begin
    full_path = File.join(RAILS_ROOT, 'public/', record.public_filename)
    watermark_path = File.join(RAILS_ROOT, 'public/', 'images/watermark_logo.png')
    if File.exists?(full_path) && File.exists?(watermark_path) && full_path[-10..-5] != "_thumb" && full_path[-11..-5] != "_medium"
      dst = Magick::ImageList.new(full_path).first
      src = Magick::Image.read(watermark_path).first
      result = dst.composite(src, Magick::SouthWestGravity, Magick::OverCompositeOp)
      result.write(full_path)
      #result

    end
      
    rescue

    end
  end
  validates_as_attachment
  
  
  # 修改上传图片的名称
  def uploaded_data=(file_data)
    super
    self.filename = 'img' + Time.now.to_f.to_s.gsub('.','') + File.extname(file_data.original_filename)
  end
end
