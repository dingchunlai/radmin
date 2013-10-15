# == Schema Information
#
# Table name: HEJIA_DESIGNERMODEL
#
#  ID        :integer(19)     not null
#  COMPANY   :integer(19)
#  DESAGE    :string(510)
#  DESFEE    :string(510)
#  DESNAME   :string(510)
#  DESRESUME :string(510)
#  DESSCHOOL :string(510)
#  DESTEL    :string(510)
#  PICURL    :string(510)
#  WORKAGE   :string(510)
#  DESSTYLE  :string(510)
#  STATUS    :string(510)
#  GLORY     :string(1000)
#  GRADE     :string(255)
#  POSITION  :string(255)
#

class DecoDesigner < ActiveRecord::Base
  self.table_name = "HEJIA_DESIGNERMODEL"
  acts_as_list :column => 'LIST_INDEX'
end
