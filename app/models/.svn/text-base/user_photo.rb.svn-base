# == Schema Information
#
# Table name: user_photos
#
#  id         :integer(11)     not null, primary key
#  descript   :string(255)
#  title      :string(255)
#  types      :string(255)
#  imageurl   :string(255)
#  note_id    :integer(11)
#  room       :integer(4)
#  price      :integer(4)
#  methodtype :integer(4)
#  style      :integer(4)
#  stage      :integer(4)
#  status     :integer(11)
#  created_at :datetime
#  updated_at :datetime
#  space      :integer(4)
#  user_id    :integer(11)
#  user_name  :string(20)
#

class UserPhoto < ActiveRecord::Base
  belongs_to :note,
  :class_name => "UserNote",
  :foreign_key => "note_id"
  
end
