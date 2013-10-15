class ArticleMain < ActiveRecord::Base
  belongs_to :brand,
  :class_name => "Article",
  :foreign_key => "article_id"

  has_attachment :content_type => :image,
  :storage => :file_system,
  :path_prefix => "public/files/hekea/article_img/sourceImage",
  # :size => 1.kilobytes .. 2.megabytes,
  :max_size => 500.kilobyte,
  :thumbnails => { :thumb => '240x160', :medium => '480x320',},
  :processor => :Rmagick
  
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
    str_now = now.to_i.to_s
    str_now = left(str_now, str_now.length-2)
    self.filename = 'img'+now.strftime("%Y%m%d").to_s+str_now.to_s+rand(11-99).to_s+File.extname(file_data.original_filename)
  end
end
