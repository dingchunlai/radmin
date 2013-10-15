# == Schema Information
#
# Table name: pen_names
#
#  id        :integer(11)     not null, primary key
#  user_id   :integer(11)
#  name      :string(255)
#  ischoice  :integer(1)
#  status    :string(50)
#  create_at :datetime
#  update_at :datetime
#

class PenName < ActiveRecord::Base
  self.table_name = "pen_names"
  self.primary_key = "id"
end
