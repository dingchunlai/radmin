# == Schema Information
# Schema version: 11
#
# Table name: HEJIA_FACTORY_COMPANY
#
#  ID          :integer(19)     not null
#  COMPANYID   :integer(19)
#  CREATETIME  :datetime
#  DESCRIPTION :string(510)
#  ENDENABLE   :datetime
#  FANGXING    :string(510)
#  NAME        :string(510)
#  PROVINCE1   :integer(19)
#  PROVINCE2   :integer(19)
#  STARTENABLE :datetime
#  PAIXUMA     :integer(19)
#  CONDITION   :string(510)
#  STYLE       :string(510)
#  MONEY       :string(510)
#

class DecoFactory < ActiveRecord::Base
  self.table_name = "HEJIA_FACTORY_COMPANY"
  acts_as_list :column => 'LIST_INDEX'
  has_many :registers, :class_name => "DecoRegister", :foreign_key => "event_id"
  belongs_to :firm, :class_name => "DecoFirm", :foreign_key => "COMPANYID"
  def self.getarea(id)
    if !id.nil?&&id.to_i!=0
      tagname = "decofactory_case_factory_key_#{Time.now.strftime('%Y%m%d%H')}_#{id}"
      if CACHE.get(tagname).nil?
        t = ArticleTag.find(id)
        tag = t.TAGNAME
        CACHE.set(tagname, tag)
      else
        tag = CACHE.get(tagname)
      end
      return tag
    else
      return ""
    end
  end
end
