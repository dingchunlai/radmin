# == Schema Information
# Schema version: 11
#
# Table name: HEJIA_USER_ACTIVITY
#
#  ID               :integer(19)     not null, primary key
#  ACTIVITYID       :integer(19)
#  ADDRESS          :string(510)
#  AGE              :string(510)
#  BUDGET           :string(510)
#  EMAIL            :string(510)
#  EXPECTHOUSEMODEL :string(510)
#  EXPECTPERSONNUM  :integer(19)
#  HOUSEADDRESS     :string(510)
#  HOUSEAREA        :string(510)
#  HOUSEMODEL       :string(510)
#  HOUSEMODELIMAGE  :string(510)
#  HOUSESTYLE       :string(510)
#  HOUSETIME        :string(510)
#  HOUSETYPE        :string(510)
#  MOBILE           :string(510)
#  MSN              :string(510)
#  NAME             :string(510)
#  OCCUPATION       :string(510)
#  PHONE            :string(510)
#  POSTCODE         :string(510)
#  QQ               :string(510)
#  REMARK           :string(510)
#  CREATETIME       :datetime
#  SEX              :string(510)
#  USERFAVORTAG     :string(510)
#  AREA             :string(510)
#  SALARY           :string(510)
#

class HejiaUserActivity < ActiveRecord::Base
  self.table_name = "HEJIA_USER_ACTIVITY"
  self.primary_key = "ID"
end
