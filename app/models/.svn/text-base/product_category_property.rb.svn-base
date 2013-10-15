class ProductCategoryProperty < Hejia::Db::Product
  acts_as_list :scope => :category

  validates_presence_of :category_id, :name

  belongs_to :category, :class_name => "ProductCategory", :foreign_key => "category_id"
  has_many :product_properties, :class_name => "ProductProperty", :foreign_key => "property_id"

  attr_accessor :category_parent_id
end
