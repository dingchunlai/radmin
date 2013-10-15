class VendorPoint < Hejia::Db::Product
  belongs_to :vendor, :class_name => "ProductVendor", :foreign_key => "vendor_id"
  belongs_to :user, :class_name => "HejiaUserBbs", :foreign_key => "user_id"

  validates_presence_of :point
  validates_presence_of :reason
end
