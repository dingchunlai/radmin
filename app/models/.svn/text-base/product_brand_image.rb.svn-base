class ProductBrandImage < Hejia::Db::Product
  belongs_to :brand, :class_name => "ProductBrand", :foreign_key => "brand_id"
  has_attachment :content_type => :image, 
                   :storage => :file_system, 
                   :path_prefix => "public/images/brands",
                   :max_size => 500.kilobytes,
                   #:resize_to => '320x200',
                   :thumbnails => { :thumb => '120x80', :medium => '240x160' },
                   :processor => :Rmagick
  validates_as_attachment
  
  def full_path
    path_prefix = BRAND_LOGO_PATH_PREFIX
    path = ""
    path << path_prefix
    path << self.filename
    return path
  end
end
