class ProductQuote < Hejia::Db::Product
  validates_presence_of :product_id, :vendor_id, :price
  
  belongs_to :product, :class_name => "Product", :foreign_key => "product_id"
  belongs_to :vendor, :class_name => "ProductVendor", :foreign_key => "vendor_id"
end
