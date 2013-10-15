# == Schema Information
#
# Table name: HEJIA_TAGLINK
#
#  TAGLINKID :integer(19)     not null, primary key
#  TAGID1    :string(510)     default(""), not null
#  TAGID2    :string(510)     default(""), not null
#

class HejiaTaglink < ActiveRecord::Base
  self.table_name = "HEJIA_TAGLINK"
  self.primary_key = "TAGLINKID"

  # 取得某一类下的TAGS
  # 此处创建的目的主要是获取品牌的所有行业
  def self.type_tags(tagid1)
    find(:all, :conditions => ["TAGID1 = ?", tagid1])
  end
end
