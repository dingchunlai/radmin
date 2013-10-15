class LibraryBrand < Hejia::Db::Product
  belongs_to :brand, :class_name => "ProductBrand", :foreign_key => "brand_id"
  belongs_to :category, :class_name => "ProductCategory", :foreign_key => "category_id"

  PRODUCT_ORDER = [[1,"热门"], [2,"最新"]]
  BRAND_TREND = [[-1,"下降"], [0,"平稳"], [1,"上升"]]

  attr_accessor :category_parent_id

  validates_presence_of :name, :brand_id, :category_id, :brand_subject_id, 
    :shopping_article_id, :category_article_id, :comment, :manufacturer
end
