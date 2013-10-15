class BrandExperience < Hejia::Db::Product
  validates_presence_of :brand_id, :category_id, :experience_id
  
  belongs_to :brand, :class_name => "ProductBrand", :foreign_key => "brand_id"
  belongs_to :category, :class_name => "ProductCategory", :foreign_key => "category_id"
  belongs_to :category_experience, :class_name => "ProductCategoryExperience", :foreign_key => "experience_id"
end
