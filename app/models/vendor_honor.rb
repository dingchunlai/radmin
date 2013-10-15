class VendorHonor < Hejia::Db::Product
  #acts_as_paranoid
  has_attached_file :image, :styles => { :thumb => "156x117", :medium => "350x460" },
    :path => ":rails_root/public/vendors/:class/:attachment/:id/:style/:basename.:extension",
    :url => "/vendors/:class/:attachment/:id/:style/:basename.:extension",
    :default_url => "/images/missing.gif"
  validates_presence_of :title, :image
  belongs_to :vendor, :class_name => "ProductVendor", :foreign_key => "vendor_id"
end
