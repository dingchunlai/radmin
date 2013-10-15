# == Schema Information
#
# Table name: dianxings
#
#  id                    :integer(11)     not null, primary key
#  name                  :string(32)
#  spell                 :string(32)
#  style                 :integer(4)      default(1), not null
#  is_delete             :integer(4)      default(0), not null
#  created_at            :datetime
#  updated_at            :datetime
#  friendly_links        :string(1024)
#  tuku_kw               :string(64)
#  headline_title        :string(64)
#  headline_resume       :string(96)
#  headline_url          :string(96)
#  html_title            :string(64)
#  html_keywords         :string(128)
#  html_description      :string(256)
#  pd_tuijian            :string(512)
#  pd_daohang1           :string(64)
#  pd_daohang2           :string(64)
#  pd_daohang3           :string(64)
#  pd_daohang4           :string(64)
#  pd_daohang5           :string(64)
#  pd_daohang6           :string(64)
#  pd_daohang7           :string(64)
#  pd_daohang8           :string(64)
#  pd_daohang9           :string(64)
#  tuijian_title1        :string(96)
#  tuijian_resume1       :string(96)
#  tuijian_image_url1    :string(96)
#  tuijian_url1          :string(96)
#  tuijian_title2        :string(96)
#  tuijian_resume2       :string(96)
#  tuijian_image_url2    :string(96)
#  tuijian_url2          :string(96)
#  tuijian_title3        :string(96)
#  tuijian_resume3       :string(96)
#  tuijian_image_url3    :string(96)
#  tuijian_url3          :string(96)
#  tuijian_title4        :string(96)
#  tuijian_image_url4    :string(96)
#  tuijian_url4          :string(96)
#  tuijian_bigtitle      :string(32)
#  tuijian_title5        :string(96)
#  tuijian_image_url5    :string(96)
#  tuijian_url5          :string(96)
#  tuijian_title6        :string(96)
#  tuijian_image_url6    :string(96)
#  tuijian_url6          :string(96)
#  tuijian_title7        :string(96)
#  tuijian_image_url7    :string(96)
#  tuijian_url7          :string(96)
#  tuijian_title8        :string(96)
#  tuijian_image_url8    :string(96)
#  tuijian_url8          :string(96)
#  tuijian_title9        :string(96)
#  tuijian_image_url9    :string(96)
#  tuijian_url9          :string(96)
#  jiaodiantu_title1     :string(96)
#  jiaodiantu_image_url1 :string(96)
#  jiaodiantu_url1       :string(96)
#  jiaodiantu_title2     :string(96)
#  jiaodiantu_image_url2 :string(96)
#  jiaodiantu_url2       :string(96)
#  jiaodiantu_title3     :string(96)
#  jiaodiantu_image_url3 :string(96)
#  jiaodiantu_url3       :string(96)
#  is_published          :integer(4)      default(0), not null
#  lm1_bigtitle          :string(64)
#  lm1_bigurl            :string(96)
#  lm1_tags              :string(96)
#  lm1_kws               :string(96)
#  lm1_title             :string(96)
#  lm1_resume            :string(96)
#  lm1_url               :string(96)
#  lm1_title1            :string(96)
#  lm1_image_url1        :string(96)
#  lm1_url1              :string(96)
#  lm1_title2            :string(96)
#  lm1_image_url2        :string(96)
#  lm1_url2              :string(96)
#  lm1_title3            :string(96)
#  lm1_image_url3        :string(96)
#  lm1_url3              :string(96)
#  lm1_title4            :string(96)
#  lm1_image_url4        :string(96)
#  lm1_url4              :string(96)
#  lm1_title5            :string(96)
#  lm1_image_url5        :string(96)
#  lm1_url5              :string(96)
#  lm2_bigtitle          :string(64)
#  lm2_bigurl            :string(96)
#  lm2_tags              :string(96)
#  lm2_kws               :string(96)
#  lm2_title             :string(96)
#  lm2_resume            :string(96)
#  lm2_url               :string(96)
#  lm2_title1            :string(96)
#  lm2_image_url1        :string(96)
#  lm2_url1              :string(96)
#  lm2_title2            :string(96)
#  lm2_image_url2        :string(96)
#  lm2_url2              :string(96)
#  lm2_title3            :string(96)
#  lm2_image_url3        :string(96)
#  lm2_url3              :string(96)
#  lm2_title4            :string(96)
#  lm2_image_url4        :string(96)
#  lm2_url4              :string(96)
#  lm2_title5            :string(96)
#  lm2_image_url5        :string(96)
#  lm2_url5              :string(96)
#  lm3_bigtitle          :string(64)
#  lm3_bigurl            :string(96)
#  lm3_tags              :string(96)
#  lm3_kws               :string(96)
#  lm3_title             :string(96)
#  lm3_resume            :string(96)
#  lm3_url               :string(96)
#  lm3_title1            :string(96)
#  lm3_image_url1        :string(96)
#  lm3_url1              :string(96)
#  lm3_title2            :string(96)
#  lm3_image_url2        :string(96)
#  lm3_url2              :string(96)
#  lm3_title3            :string(96)
#  lm3_image_url3        :string(96)
#  lm3_url3              :string(96)
#  lm3_title4            :string(96)
#  lm3_image_url4        :string(96)
#  lm3_url4              :string(96)
#  lm3_title5            :string(96)
#  lm3_image_url5        :string(96)
#  lm3_url5              :string(96)
#  lm4_bigtitle          :string(64)
#  lm4_bigurl            :string(96)
#  lm4_tags              :string(96)
#  lm4_kws               :string(96)
#  lm4_title             :string(96)
#  lm4_resume            :string(96)
#  lm4_url               :string(96)
#  lm4_title1            :string(96)
#  lm4_image_url1        :string(96)
#  lm4_url1              :string(96)
#  lm4_title2            :string(96)
#  lm4_image_url2        :string(96)
#  lm4_url2              :string(96)
#  lm4_title3            :string(96)
#  lm4_image_url3        :string(96)
#  lm4_url3              :string(96)
#  lm4_title4            :string(96)
#  lm4_image_url4        :string(96)
#  lm4_url4              :string(96)
#  lm4_title5            :string(96)
#  lm4_image_url5        :string(96)
#  lm4_url5              :string(96)
#  lm5_bigtitle          :string(64)
#  lm5_bigurl            :string(96)
#  lm5_tags              :string(96)
#  lm5_kws               :string(96)
#  lm5_title             :string(96)
#  lm5_resume            :string(96)
#  lm5_url               :string(96)
#  lm5_title1            :string(96)
#  lm5_image_url1        :string(96)
#  lm5_url1              :string(96)
#  lm5_title2            :string(96)
#  lm5_image_url2        :string(96)
#  lm5_url2              :string(96)
#  lm5_title3            :string(96)
#  lm5_image_url3        :string(96)
#  lm5_url3              :string(96)
#  lm5_title4            :string(96)
#  lm5_image_url4        :string(96)
#  lm5_url4              :string(96)
#  lm5_title5            :string(96)
#  lm5_image_url5        :string(96)
#  lm5_url5              :string(96)
#  tg1_kw                :string(64)
#  tg1_title             :string(96)
#  tg1_resume            :string(96)
#  tg1_image_url         :string(96)
#  tg1_url               :string(96)
#  tg2_kw                :string(64)
#  tg2_title             :string(96)
#  tg2_resume            :string(96)
#  tg2_image_url         :string(96)
#  tg2_url               :string(96)
#  tg3_kw                :string(64)
#  tg3_title             :string(96)
#  tg3_resume            :string(96)
#  tg3_image_url         :string(96)
#  tg3_url               :string(96)
#  jiaodiantu_title4     :string(96)
#  jiaodiantu_image_url4 :string(96)
#  jiaodiantu_url4       :string(96)
#  jiaodiantu_title5     :string(96)
#  jiaodiantu_image_url5 :string(96)
#  jiaodiantu_url5       :string(96)
#  tuijian_ids1          :string(64)
#  tuijian_ids2          :string(64)
#  rtj_kw                :string(32)
#  jiaodiantu_order      :string(9)       default("1 2 3 4 5"), not null
#

class Dianxing < ActiveRecord::Base

  def self.updates(attributes, id)
    UtilsModule::updates(self, attributes, id)
  end

end
