class VendorBanner < Hejia::Db::Product
  #acts_as_paranoid
  has_attached_file :image, :styles => { :normal => "960x191>", :thumb => "100x50>" },
    :path => ":rails_root/public/vendors/:class/:attachment/:id/:style/:basename.:extension",
    :url => "/vendors/:class/:attachment/:id/:style/:basename.:extension",
    :default_url => "/images/missing.gif"
  validates_presence_of :title, :image
  belongs_to :vendor, :class_name => "ProductVendor", :foreign_key => "vendor_id"
end
