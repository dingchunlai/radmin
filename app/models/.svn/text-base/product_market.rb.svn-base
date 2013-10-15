class ProductMarket < Hejia::Db::Product
  has_many :vendors, :class_name => "ProductVendor", :foreign_key => "market_id"
  has_one :image, :class_name => "ProductMarketImage", :foreign_key => "market_id", :dependent => :destroy

  def categories
    vendors.collect {|v| v.categories}.flatten!.uniq
  end

  def products
    vendors.collect {|v| v.products}.flatten!
  end

  def logo
    path = ""
    path << (self.image ? self.image.full_path : MARKET_DEFAULT_LOGO_PATH)
    return path
  end

end
