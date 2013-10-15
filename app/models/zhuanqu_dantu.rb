# == Schema Information
#
# Table name: zhuanqu_dantus
#
#  id               :integer(11)     not null, primary key
#  name             :string(64)
#  sort_id          :integer(4)      default(0), not null
#  description      :string(512)
#  about_links      :string(1024)
#  html_title       :string(128)
#  html_keywords    :string(256)
#  html_description :string(256)
#  is_delete        :integer(4)      default(0), not null
#  created_at       :datetime
#  updated_at       :datetime
#  split            :string(64)
#  is_published     :integer(4)      default(0), not null
#  haoping          :integer(6)      default(0), not null
#  chaping          :integer(6)      default(0), not null
#

class ZhuanquDantu < ActiveRecord::Base
end
