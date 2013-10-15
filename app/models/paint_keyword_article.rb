class PaintKeywordArticle < Hejia::Db::Hejia
	belongs_to :paint_keyword, :class_name => "PaintKeyword", :foreign_key => "paint_keyword_id"
	belongs_to :article, :class_name => "Article", :foreign_key => "article_id"
end