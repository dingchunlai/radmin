class ProductImage < Hejia::Db::Product
  acts_as_tree
  belongs_to :product
  has_attachment :content_type => :image,
                   :storage => :file_system,
                   :path_prefix => "public/images/products",
                   :max_size => 2048.kilobytes,
                   #:resize_to => '320x200',
                   :thumbnails => { :small => '80x60', :thumb => '150x113>', :medium => '280x210>' },
                   :processor => :Rmagick
  validates_as_attachment

  def full_path(thumbnail = nil)
    path_prefix = PRODUCT_IMAGES_PATH_PREFIX
    path = ""
    if File.split(self.filename)[0] == "source1"
      path << "/"
      path << (thumbnail ? (File.split(self.filename)[0] + "/" + File.split(self.filename)[1] + "/tn/" + File.split(self.filename)[2]) : self.filename)
    elsif self.filename.include?("/") || self.filename.length == 28
      path << path_prefix
      if self.filename.length == 28
        path << self.filename[3,8]
        path << "/"
        path << "tn/" if thumbnail
        path << self.filename
      else
        #path << "/"
        path << (thumbnail ? (File.split(self.filename)[0] + "/tn/" + File.split(self.filename)[1]) : self.filename)
      end
    else
      path << self.public_filename(thumbnail)
    end
    return path
  end

end
