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

class HejiaDesignerModel < ActiveRecord::Base
  self.table_name = "HEJIA_DESIGNERMODEL"
  #  acts_as_readonlyable [:read_only_51hejia]

  def self.query_by_name(name, page, per_page)
    return HejiaDesignerModel.find(:all,
      :conditions => ["STATUS != ? and DESNAME like '%#{name}%'", -100]).paginate(:page => page, :per_page => per_page)
  end

end
