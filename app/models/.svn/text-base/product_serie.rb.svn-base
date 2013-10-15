class ProductSerie < Hejia::Db::Product
  validates_presence_of :brand_id, :name

  belongs_to :brand, :class_name => "ProductBrand", :foreign_key => "brand_id"
  belongs_to :category, :class_name => "ProductCategory", :foreign_key => "category_id"
  has_many :products, :foreign_key => "serie_id", :dependent => :nullify
end
