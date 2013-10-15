class ProductPricing < Hejia::Db::Product
  belongs_to :product, :class_name => "Product", :foreign_key => "proid"
  has_one :bill, :class_name => "ProductPricingBill", :foreign_key => "pricing_id"

  validates_presence_of :name, :username, :phone, :message => "不能为空！"
  validates_format_of :phone, :with => /(^[0-9]{3,4}\-[0-9]{7,8}$)|(^[0-9]{7,8}$)|(^\([0-9]{3,4}\)[0-9]{3,8}$)|(^0{0,1}1[358][0-9]{9}$)/, :on => :create

  def self.undone_items(cookies)
    find(:all, :conditions => ["product_pricings.userid = ?", cookies], :order => "product_pricings.createtime desc")
  end
end
