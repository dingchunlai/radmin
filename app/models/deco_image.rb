# == Schema Information
# Schema version: 11
#
# Table name: HEJIA_DECOIMAGE
#
#  ID         :integer(19)     not null
#  IMAGENAME  :string(510)
#  INTRODUCE  :string(2000)
#  MAIN       :integer(1)
#  SLIDE      :integer(1)
#  CASEID     :integer(19)
#  FLOWSTATUS :string(510)
#  USERID     :integer(19)
#

class DecoImage < ActiveRecord::Base
  self.table_name = "HEJIA_DECOIMAGE"
  
end
