class ProductCategoryParam < Hejia::Db::Product
  acts_as_list :scope => :category

  validates_presence_of :category_id, :key

  belongs_to :category, :class_name => "ProductCategory", :foreign_key => "category_id"
  has_many :param_items, :class_name => "ProductCategoryParamItem", :foreign_key => "param_id"
  has_many :product_params, :class_name => "ProductParam", :foreign_key => "param_id"

  attr_accessor :category_parent_id
end
