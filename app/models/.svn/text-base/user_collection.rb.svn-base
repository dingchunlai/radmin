# == Schema Information
#
# Table name: user_collections
#
#  id         :integer(11)     not null, primary key
#  user_id    :integer(11)
#  obj_id     :integer(11)
#  obj_name   :string(510)
#  obj_type   :integer(11)
#  url        :string(510)
#  photo_url  :string(510)
#  status     :integer(11)
#  created_at :datetime
#  updated_at :datetime
#

class UserCollection < ActiveRecord::Base
  self.table_name="user_collections"
  self.primary_key = "id"
  #obj_type 1:公司 2:案例 3：设计师
end
