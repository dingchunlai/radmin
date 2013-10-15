# == Schema Information
#
# Table name: zhuanqu_hangyes
#
#  id               :integer(11)     not null, primary key
#  name             :string(16)
#  is_delete        :integer(4)      default(0), not null
#  created_at       :datetime
#  updated_at       :datetime
#  html_title       :string(64)
#  html_keywords    :string(128)
#  html_description :string(256)
#  is_published     :integer(4)      default(0), not null
#  big_image_url    :string(96)
#  tj_title         :string(64)
#  tj_tags          :string(1024)
#  xg_title         :string(64)
#  resume_title     :string(64)
#  resume           :string(512)
#  content_title    :string(64)
#  content          :string(1024)
#  tuku_title       :string(64)
#  tuku_kw          :string(32)
#  chanpin_title    :string(64)
#  chanpin_kw       :string(32)
#

class ZhuanquHangye < ActiveRecord::Base

  def self.updates(attributes, id)
       UtilsModule::updates(self, attributes, id)
  end
end
