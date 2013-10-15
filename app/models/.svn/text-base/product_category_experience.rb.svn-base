class ProductCategoryExperience < Hejia::Db::Product
  acts_as_list :scope => :category

  validates_presence_of :category_id, :name

  belongs_to :category, :class_name => "ProductCategory", :foreign_key => "category_id"
  has_many :brand_experiences, :class_name => "BrandExperience", :foreign_key => "experience_id"

end
