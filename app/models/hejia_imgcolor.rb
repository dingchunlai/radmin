# == Schema Information
#
# Table name: HEJIA_IMGCOLOR
#
#  ID                :integer(19)     not null, primary key
#  NAME              :string(255)
#  IMAGECOLORCONTENT :string(255)
#  COLOR             :string(255)
#  STATUS            :string(255)
#  COUNT             :integer(19)
#

class HejiaImgcolor < ActiveRecord::Base
  self.table_name = "HEJIA_IMGCOLOR"
  self.primary_key = "ID"
  
end
