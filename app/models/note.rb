# == Schema Information
# Schema version: 11
#
# Table name: radmin_notes
#
#  id           :integer(11)     not null, primary key
#  sender_id    :integer(11)     default(0), not null
#  receiver_id  :integer(11)     default(0), not null
#  content      :string(512)
#  created_at   :datetime
#  is_read      :integer(4)      default(0), not null
#  sender_del   :integer(4)      default(0), not null
#  receiver_del :integer(4)      default(0), not null
#

class Note < ActiveRecord::Base
  self.table_name = "radmin_notes"
end
