# == Schema Information
#
# Table name: HEJIA_CASECOLOREY
#
#  ID      :integer(19)     not null, primary key
#  CASEID  :integer(19)
#  COLORID :integer(19)
#  ADDRESS :string(255)
#  NAME    :string(255)
#  COLOR   :string(255)
#

class HejiaColorlink < ActiveRecord::Base
  self.table_name = "HEJIA_CASECOLOREY"
  self.primary_key = "ID"
end
