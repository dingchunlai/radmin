# == Schema Information
#
# Table name: editor_case_photo
#
#  id         :integer(11)     not null, primary key
#  editor_id  :integer(11)
#  case_id    :integer(11)
#  photo      :integer(11)
#  state      :integer(11)
#  updated_at :datetime
#  created_at :datetime
#

class EditorCasePhoto < ActiveRecord::Base
  self.table_name = "editor_case_photo"
  
end
