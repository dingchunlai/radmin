class ProductProperty < Hejia::Db::Product
  validates_presence_of :product_id, :property_id, :value

  acts_as_list :scope => :product
  belongs_to :product
  belongs_to :cproperty, :class_name => "ProductCategoryProperty", :foreign_key => "property_id"
end
