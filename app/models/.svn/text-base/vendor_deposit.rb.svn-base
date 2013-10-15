class VendorDeposit < Hejia::Db::Product
  belongs_to :vendor, :class_name => "Vendor", :foreign_key => "vendor_id"

  validates_presence_of :amount, :vendor_id
end
