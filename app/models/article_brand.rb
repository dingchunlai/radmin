class ArticleBrand < Hejia::Db::Product
  self.table_name = "product_brands"
  has_many :article,
           :class_name => "Article"
end
