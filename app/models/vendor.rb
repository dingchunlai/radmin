class Vendor < Hejia::Db::Product
  self.table_name = "product_vendors"
#  belongs_to :brand, :class_name => "Brand", :foreign_key => "brand_id"
end
