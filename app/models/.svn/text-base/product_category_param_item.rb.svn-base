class ProductCategoryParamItem < Hejia::Db::Product
  acts_as_list :scope => :param

  belongs_to :param, :class_name => "ProductCategoryParam", :foreign_key => "param_id"
  has_many :product_params, :class_name => "ProductParam", :foreign_key => "param_item_id"
end
