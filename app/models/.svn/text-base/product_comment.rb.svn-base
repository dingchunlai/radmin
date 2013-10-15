class ProductComment < Hejia::Db::Product
  acts_as_tree

  belongs_to :product
  belongs_to :brand,  :class_name => "ProductBrand",  :foreign_key => "brand_id"
  belongs_to :vendor, :class_name => "ProductVendor", :foreign_key => "vendor_id"
  belongs_to :user,   :class_name => "HejiaUserBbs",  :foreign_key => "user_id"
  belongs_to :city

  validates_presence_of :city_id
  validates_presence_of :title

  attr_accessor :province_id
end
