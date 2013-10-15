# == Schema Information
#
# Table name: photo_ad_codes
#
#  id            :integer(11)     not null, primary key
#  tag_id        :integer(11)
#  tag_url       :string(255)
#  ad_code       :text
#  created_at    :datetime
#  updated_at    :datetime
#  tag_father_id :integer(11)
#

class AdCode < ActiveRecord::Base
  self.table_name = "photo_ad_codes"

  validates_presence_of :tag_id, :ad_code
end
