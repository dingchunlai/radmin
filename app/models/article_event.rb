# == Schema Information
#
# Table name: 51hejia.hejia_events
#
#  id          :integer(19)     not null, primary key
#  name        :string(50)
#  permalink   :string(50)
#  description :string(100)
#  is_valid    :integer(4)
#  created_at  :datetime
#  updated_at  :datetime
#

class ArticleEvent < ActiveRecord::Base
  self.table_name = "51hejia.hejia_events"
  self.primary_key = "id"
end
