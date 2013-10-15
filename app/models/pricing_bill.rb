class PricingBill < Hejia::Db::Product
  belongs_to :pricing, :class_name => "PricingBill", :foreign_key => "pricing_id"
  self.table_name = "product_pricing_bills"
end
