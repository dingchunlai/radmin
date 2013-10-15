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

# -*- coding: utf-8 -*-
class ArticleTag < ActiveRecord::Base
  self.table_name = "HEJIA_TAG"
  self.primary_key = "TAGID"

  include HejiaCouponSerializable
  hejia_set_serialization ('a'..'z').to_a.concat((0..9).to_a)

  def serialization_key
    'hejia:coupon:tag:code'
  end

  has_and_belongs_to_many :sonlist,
  :class_name => "ArticleTag",
  :join_table => "HEJIA_TAGLINK",
  :foreign_key => "TAGID1",
  :association_foreign_key => "TAGID2",
  :conditions => "TAGESTATE = 0"

  #文章大分类 -- first :controller => article , :action => new
  def self.article_categories
    find(:all ,:conditions =>["TAGFATHERID = ? and TAGESTATE = '0'",14025])
  end

  def self.aft
    find(:all,:conditions=>["TAGID in (31871,35762,35763,35764,35765,35766,35767,35768,35769,35770,35771,35772)"])
  end

  def self.at
    find(:all, :conditions=>["TAGFATHERID in (31871,35762,35763,35764,35765,35766,35767,35768,35769,35770,35771,35772)"])
  end

  def self.related_brand
    find(:first, :conditions => "TAGFATHERID = 14025 and TAGURL = 'pinpaiku'")
  end

  # 取得指定名称的品类，包括正在使用的和已经停用的。
  # @param [String] name 品类名称，模糊匹配。若不指定，则找出所有的。
  def self.all_categories(name = nil)
    condition_sql = sanitize_sql_array ['link.TAGID1 = ?', 42092]
    condition_sql << " AND %s" % sanitize_sql_array(['TAGNAME like ?', "%#{name}%"]) unless name.blank?
    ArticleTag.find_by_sql "SELECT `HEJIA_TAG`.* FROM `HEJIA_TAG` JOIN HEJIA_TAGLINK as link on HEJIA_TAG.TAGID = link.TAGID2 WHERE ((TAGESTATE = '0' OR TAGESTATE = '1') AND #{condition_sql}) ORDER BY priority DESC"
  end


  # 迫不得已在保存完Hejia_Taglink后才能能修改Hejia_tag的code（序列值）
  # 本身此处的操作是在创建成功后调用
  def serializable_code
    links =  HejiaTaglink.type_tags(ArticleTag.related_brand.TAGID).map{|t| t.TAGID2.to_i }
    if links.include?(self.TAGID)
      update_attribute(:code, self.next_success)
    end
  end

end
