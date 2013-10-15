# == Schema Information
#
# Table name: HEJIA_COMPANY_PHOTO
#
#  ID            :integer(19)     not null, primary key
#  CONTENT       :string(510)
#  ENTITYID      :integer(19)
#  ENTITYTYPE    :string(510)
#  IMAGENAME     :string(510)
#  STATE         :string(510)
#  DEMONSTRATION :string(510)
#  PHOTOTYPE     :string(510)
#  ORDERNUMBER   :integer(19)
#  URL           :string(510)
#

class CompanyPhoto < ActiveRecord::Base
  self.table_name = "HEJIA_COMPANY_PHOTO"
  self.primary_key = "ID"
end
