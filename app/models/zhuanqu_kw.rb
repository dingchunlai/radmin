# == Schema Information
#
# Table name: zhuanqu_kws
#
#  id               :integer(11)     not null, primary key
#  sort_id          :integer(11)
#  kw_name          :string(16)
#  is_delete        :integer(4)      default(0), not null
#  created_at       :datetime
#  updated_at       :datetime
#  description      :string(512)
#  ha_title1        :string(64)
#  ha_title2        :string(64)
#  ha_title3        :string(64)
#  ha_url1          :string(128)
#  ha_url2          :string(128)
#  ha_url3          :string(128)
#  hot1_title1      :string(64)
#  hot1_url1        :string(128)
#  hot1_title2      :string(64)
#  hot1_resume2     :string(64)
#  hot1_image_url2  :string(128)
#  hot1_url2        :string(128)
#  hot1_title3      :string(64)
#  hot1_url3        :string(128)
#  hot1_title4      :string(64)
#  hot1_url4        :string(128)
#  hot1_title5      :string(64)
#  hot1_url5        :string(128)
#  hot2_title1      :string(64)
#  hot2_url1        :string(128)
#  hot2_title2      :string(64)
#  hot2_resume2     :string(64)
#  hot2_image_url2  :string(128)
#  hot2_url2        :string(128)
#  hot2_title3      :string(64)
#  hot2_url3        :string(128)
#  hot2_title4      :string(64)
#  hot2_url4        :string(128)
#  hot2_title5      :string(64)
#  hot2_url5        :string(128)
#  zt_title1        :string(64)
#  zt_image_url1    :string(128)
#  zt_url1          :string(128)
#  zt_title2        :string(64)
#  zt_image_url2    :string(128)
#  zt_url2          :string(128)
#  zt_title3        :string(64)
#  zt_image_url3    :string(128)
#  zt_url3          :string(128)
#  zt_title4        :string(64)
#  zt_image_url4    :string(128)
#  zt_url4          :string(128)
#  about_image_url  :string(128)
#  html_title       :string(64)
#  html_keywords    :string(128)
#  html_description :string(256)
#  image_keyword    :string(64)
#  is_published     :integer(4)      default(0), not null
#

class ZhuanquKw < ActiveRecord::Base
  
  belongs_to :sort, :class_name => "ZhuanquSort", :foreign_key => "sort_id"

end
