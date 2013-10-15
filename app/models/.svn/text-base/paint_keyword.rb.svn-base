class PaintKeyword < Hejia::Db::Hejia
	validates_presence_of :name, :message => "油工关键词名称不能为空!"
	validates_uniqueness_of :name, :message => "油工关键词已经存在!"

	has_many :paint_keyword_articles
	has_many :articles, :through => :paint_keyword_articles, :source => :article
end