# == Schema Information
#
# Table name: user_notes
#
#  id           :integer(11)     not null, primary key
#  title        :string(100)
#  main_photo   :string(100)
#  content      :string(510)
#  user_id      :integer(11)
#  room         :integer(4)
#  price        :integer(4)
#  methodtype   :integer(4)
#  style        :integer(4)
#  status       :integer(11)
#  created_at   :datetime
#  updated_at   :datetime
#  firm_id      :integer(11)
#  dianping_id  :integer(11)
#  pv           :integer(11)
#  is_good      :integer(11)
#  last_updater :integer(11)
#

class UserNote < ActiveRecord::Base
  def self.get_note_has(id)
    conditions = []
    conditions << "status !='-1'"
    conditions << "user_id = #{id}"
    note = UserNote.find(:all,:conditions =>  conditions.join(' and '),:order => "id desc")
    return note
  end
end
