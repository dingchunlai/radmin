class ProductVendor < Hejia::Db::Product
  attr_accessor :plain_password

  has_attached_file :banner, :styles => { :original => "950x200", :thumb => "400x84" },
    :path => ":rails_root/public/vendors/:class/:attachment/:id/:style/:basename.:extension",
    :url => "/vendors/:class/:attachment/:id/:style/:basename.:extension",
    :default_url => "/images/missing.gif"

  has_and_belongs_to_many :categories, :class_name => "ProductCategory",
                             :join_table => "product_categories_vendors",
                             :foreign_key => "vendor_id",
                             :association_foreign_key => "category_id"
  has_and_belongs_to_many :brands, :class_name => "ProductBrand",
                             :join_table => "product_brands_vendors",
                             :foreign_key => "vendor_id",
                             :association_foreign_key => "brand_id"
  #has_many :products, :foreign_key => "vendor_id"
  belongs_to :market, :class_name => "ProductMarket", :foreign_key => "market_id", :counter_cache => :vendors_count
  has_one :image, :class_name => "ProductVendorImage", :foreign_key => "vendor_id", :dependent => :destroy
  has_many :pricings, :class_name => "ProductPricing", :foreign_key => "vendor_id"
  has_many :comments, :class_name => "ProductComment", :foreign_key => "vendor_id"
  has_many :deposits, :class_name => "VendorDeposit", :foreign_key => "vendor_id"
  has_many :promotions, :class_name => "VendorPromotion", :foreign_key => "vendor_id"
  has_many :banners, :class_name => "VendorBanner", :foreign_key => "vendor_id"
  has_many :sales, :class_name => "VendorSale", :foreign_key => "vendor_id"
  has_many :honors, :class_name => "VendorHonor", :foreign_key => "vendor_id"
  has_many :cases, :class_name => "VendorCase", :foreign_key => "vendor_id"
  has_many :vendor_points, :class_name => "VendorPoint", :foreign_key => "vendor_id"
  has_many :quotes, :class_name => "ProductQuote", :foreign_key => "vendor_id"
  has_many :products, :through => :quotes

  validates_presence_of :company_name
  validates_presence_of :name_zh
  validates_presence_of :open_time
  validates_presence_of :address
  validates_presence_of :contact
  validates_presence_of :telephone

  THEMES = {
    'orange' => '橙色',
    'blue' => '蓝色',
    'red' => '红色',
    'green' => '绿色',
    'purple' => '紫色'
  }

  def hot_products
    find(:all, :limit => 5, :order => "view_count desc")
  end

  def logo
    path = ""
    path << (self.image ? self.image.full_path(:thumb) : VENDOR_DEFAULT_LOGO_PATH)
    return path
  end

  def product_categories
    products.collect {|p| p.category}.compact.uniq
  end

  def valid_products
    products.find(:all, :conditions => ["is_delete = ?", false])
  end

  def full_address
    str = ""
    str << province if province
    str << city if city
    str << address if address
    str << "(#{zip_code})"
    return str
  end

  def product_quote(product)
    quotes.find(:first, :conditions => ["product_id = ?", product.id])
  end

end
