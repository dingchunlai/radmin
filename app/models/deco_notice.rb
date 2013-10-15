# == Schema Information
# Schema version: 11
#
# Table name: HEJIA_COMPANY_INFO
#
#  ID          :integer(19)     not null
#  INFO        :text
#  NEWACTIVITY :text
#  STATUS      :integer(10)
#

class DecoNotice < ActiveRecord::Base
  self.table_name = "HEJIA_COMPANY_INFO"
end
