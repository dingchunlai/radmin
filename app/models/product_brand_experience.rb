class ProductBrandExperience < Hejia::Db::Product
  acts_as_tree :order => "position"
  acts_as_list :scope => :brand
  belongs_to :brand, :class_name => "ProductBrand", :foreign_key => "brand_id"
  belongs_to :category, :class_name => "ProductCategory", :foreign_key => "category_id"

  validates_presence_of :brand_id, :category_id, :name
end
