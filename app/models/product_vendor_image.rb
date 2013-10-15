class ProductVendorImage < Hejia::Db::Product
  belongs_to :vendor, :class_name => "ProductVendor", :foreign_key => "vendor_id"
  has_attachment :content_type => :image, 
                   :storage => :file_system, 
                   :path_prefix => "public/images/vendors",
                   :max_size => 2048.kilobytes,
                   #:resize_to => '320x200',
                   :thumbnails => { :thumb => '120x80', :medium => '240x160' },
                   :processor => :Rmagick
  validates_as_attachment

#  def full_path
#    path_prefix = VENDOR_LOGO_PATH_PREFIX
#    path = ""
#    path << path_prefix
#    path << self.filename
#    return path
#  end

  def full_path(thumbnail = nil)
    path_prefix = VENDOR_LOGO_PATH_PREFIX
    path = ""
    if self.filename.length == 17 && self.filename.match(/\d{13}.(jpg|jpeg|png|gif)/)
      path << path_prefix
      path << self.filename
    else
      path << self.public_filename(thumbnail)
    end
    return path
  end

end
