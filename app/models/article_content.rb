# == Schema Information
# Schema version: 11
#
# Table name: HEJIA_ARTICLE_CONTENT
#
#  ID      :integer(19)     not null, primary key
#  CONTENT :text
#

class ArticleContent < ActiveRecord::Base
  self.table_name = "HEJIA_ARTICLE_CONTENT"
  self.primary_key = "ID"
end
