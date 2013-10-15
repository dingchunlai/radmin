class ProductParam < Hejia::Db::Product
  belongs_to :product
  belongs_to :cparam, :class_name => "ProductCategoryParam", :foreign_key => "param_id"
  belongs_to :cparam_item, :class_name => "ProductCategoryParamItem", :foreign_key => "param_item_id"
end
