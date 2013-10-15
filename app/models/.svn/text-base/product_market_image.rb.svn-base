class ProductMarketImage < Hejia::Db::Product
  belongs_to :market, :class_name => "ProductMarket", :foreign_key => "market_id"
  has_attachment :content_type => :image, 
                   :storage => :file_system, 
                   :path_prefix => "public/market_images",
                   :max_size => 500.kilobytes,
                   #:resize_to => '320x200',
                   :thumbnails => { :thumb => '120x80', :medium => '240x160' },
                   :processor => :Rmagick
  validates_as_attachment

  def full_path
    path_prefix = MARKET_LOGO_PATH_PREFIX
    path = ""
    path << path_prefix
    path << self.filename[3,8]
    path << "/"
    path << self.filename
    return path
  end
end
