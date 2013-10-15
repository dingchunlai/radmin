# == Schema Information
#
# Table name: HEJIA_COMPANY_SHOP
#
#  ID          :integer(19)     not null, primary key
#  SHOPADD     :string(510)
#  SHOPCONTACT :string(510)
#  SHOPFAX     :string(510)
#  SHOPNAME    :string(510)
#  SHOPTEL     :string(510)
#  COMPANYID   :integer(19)
#  ADDRESS     :string(510)
#

class CompanyShop < ActiveRecord::Base
  self.table_name = "HEJIA_COMPANY_SHOP"
  self.primary_key = "ID"
end
