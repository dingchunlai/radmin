# == Schema Information
#
# Table name: HEJIA_TAG
#
#  TAGID       :integer(19)     not null, primary key
#  TAGFATHERID :integer(19)     not null
#  TAGNAME     :string(510)     default(""), not null
#  TAGVALUE    :string(4000)
#  TAGICON     :string(510)
#  TAGURL      :string(510)
#  TAGTAXIS    :integer(19)
#  TAGESTATE   :string(510)     default(""), not null
#  TAGDATE     :datetime
#  TAGCODE     :string(510)
#  TAGTYPE     :string(510)
#  BIDDING     :integer(11)
#  SPELL       :string(255)
#  TEMPURL     :string(255)
#  VERSION     :string(255)
#  TAGCOMMENT  :string(255)
#  ISIMPORTANT :boolean(1)
#

class Tag < ActiveRecord::Base
  self.table_name = "HEJIA_TAG"
  self.primary_key = "TAGID"

  belongs_to :parent, :class_name => "Tag", :foreign_key => "TAGFATHERID"
  has_many :children_tags, :class_name => "Tag", :foreign_key => "TAGFATHERID", :conditions => "TAGESTATE != -1"

  acts_as_tree :foreign_key => "TAGFATHERID"
  

  def self.get_tagid_by_tagname(tagname)
    r = self.find(:first,:select=>"TAGID",:conditions=>["TAGNAME = ?", tagname])
    if r.nil?
      tag = self.new()
      tag.TAGNAME = tagname
      tag.TAGFATHERID = 4346
      tag.TAGESTATE = 0
      tag.save
      return tag.TAGID
    else
      return r["TAGID"].to_i
    end
  end

  # 得到全国所有的省份
  # return Hash
  def self.provinces_to_hash
    provinces.inject({}) do |hash, tag|
      hash[tag.TAGID] = tag.TAGNAME
      hash
    end
  end
  
  # 得到所有省份
  # return collections
  def self.provinces
    find(:all, :select => "TAGID, TAGNAME", :conditions => ["TAGFATHERID = ? and TAGESTATE != ?", 15000, -1])
  end
  
  # 得到某个省份下所有市区
  # params[:father_id] 省份编号
  # return Hash
  def self.urban_areas_to_hash father_id
    urban_areas(father_id).inject({}) do |hash, tag|
      hash[tag.TAGID] = tag.TAGNAME
      hash
    end
  end

  # 得到某个省份下的所有市区
  # params[:father_id] 省份编号
  # return collections
  def self.urban_areas father_id
    find(:all, :select => "TAGID, TAGNAME", :conditions => ["TAGFATHERID = ? and TAGESTATE != ?", father_id, -1])
  end

  def self.get_tagname_by_tagid(tagid)
    r = self.find(:first,:select=>"TAGNAME",:conditions=>["TAGID = ?", tagid])
    if r.nil?
      return ""
    else
      return r["TAGNAME"]
    end
  end

  def self.photo_first_tag
    self.find(:all, :conditions => ["TAGFATHERID = 4346 and TAGESTATE != -1"])
  end

  def valid_children
    children.find(:all, :conditions => ["TAGESTATE != -1"])
  end
end
