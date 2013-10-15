# == Schema Information
#
# Table name: hejia_article_link
#
#  id        :integer(11)     not null, primary key
#  articleid :integer(11)
#  typeid    :integer(11)
#  create_at :datetime
#  update_at :datetime
#  typename  :string(20)
#  firstid   :integer(11)
#  secondid  :integer(11)
#

class ArticleLink < ActiveRecord::Base
    self.table_name = "hejia_article_link"
    self.primary_key = "id"
end
