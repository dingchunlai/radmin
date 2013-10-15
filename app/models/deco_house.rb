# == Schema Information
# Schema version: 11
#
# Table name: HEJIA_HOUSEMODEL
#
#  ID        :integer(19)     not null
#  IMAGENAME :string(510)
#  INTRODUCE :string(2000)
#  CASEID    :integer(19)
#  IMAGETYPE :string(510)
#

class DecoHouse < ActiveRecord::Base
  self.table_name = "HEJIA_HOUSEMODEL"
  
  belongs_to :hejia_case
  
end
