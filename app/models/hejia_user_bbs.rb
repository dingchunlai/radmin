# == Schema Information
#
# Table name: HEJIA_USER_BBS
#
#  USERBBSID             :integer(19)     not null, primary key
#  USERNAME              :string(64)      default(""), not null
#  BBSID                 :string(510)     default(""), not null
#  USERBBSADDRESS        :string(510)
#  USERBBSCODE           :string(510)
#  USERBBSEMAIL          :string(510)
#  USERBBSNAME           :string(510)
#  USERBBSREADME         :string(2048)
#  USERBBSSEX            :string(510)
#  USERBBSTEL            :string(510)
#  USERBBSROLE           :string(510)
#  ROLEADMIN             :string(255)
#  HEADIMG               :string(255)
#  MSN                   :string(255)
#  QQ                    :string(255)
#  USERBBSMOBELTELEPHONE :string(255)
#  CLIENTID              :integer(19)
#  PASSWORD              :string(510)
#  CITY                  :string(510)
#  AREA                  :string(510)
#  REPAIRENJOY           :string(510)
#  REPAIRTYPE            :string(510)
#  ISACTIVATE            :integer(1)
#  USERTYPE              :integer(10)
#  REPAIRTIME            :string(510)
#  USERVALIDAT           :string(510)
#  ISDEL                 :integer(1)
#  CREATTIME             :datetime
#  LOGINIP               :string(510)
#  LOGINDATE             :datetime
#  USERSPASSWORD         :string(510)
#  USERSLOGINNUM         :integer(19)
#  ISWESKIT              :integer(10)
#  AGE                   :integer(19)
#  BUDGET                :string(510)
#  EXPECTHOUSEADDRESS    :string(510)
#  EXPECTHOUSEMODEL      :string(510)
#  EXPECTPRODUCT         :string(510)
#  HOUSEADDRESS          :string(510)
#  HOUSEAREA             :string(510)
#  HOUSEMODEL            :string(510)
#  HOUSEMODELIMAGE       :string(510)
#  HOUSESTYLE            :string(510)
#  OCCUPATION            :string(510)
#  REMARK                :string(510)
#  EXPECTPERSONNUM       :integer(19)
#  OFTENUSEDEMAIL        :string(510)
#  USERFAVORTAG          :string(510)
#  ANJIA                 :integer(1)
#  POINT                 :integer(19)
#  MENBER                :integer(10)
#  URL                   :string(255)
#  MEMBERCODE            :string(255)
#  MEMBERSTARTTIME       :datetime
#  MEMBERENDTIME         :date
#  ACTIVEMEMBER          :integer(10)
#  MEMBERADD             :string(255)
#  deco_id               :integer(11)     default(0), not null
#  credits               :integer(11)     default(0)
#  ask_expert            :integer(4)      default(0), not null
#  ischeck               :integer(11)
#  user_id               :integer(11)
#  DESAGE                :string(510)
#  DESFEE                :string(510)
#  DESSCHOOL             :string(510)
#  PICURL                :string(510)
#  WORKAGE               :string(510)
#  DESSTYLE              :string(510)
#

# -*- coding: utf-8 -*-
class HejiaUserBbs < Hejia::Db::Hejia
  self.table_name = "HEJIA_USER_BBS"
  self.primary_key = "USERBBSID"

  after_create  :create_wenba_user,:create_boke_user

  attr_protected :mobile_verified

  validates_presence_of :USERNAME, :message => "用户名不能为空"
  validates_uniqueness_of :USERNAME, :message => "用户名已经存在"
  #validates_uniqueness_of :USERBBSEMAIL, :message => "用户邮箱已经存在"
  belongs_to :user, :class_name => "User", :foreign_key => "user_id" # 从BbsUser copy过来的，因为要把BbsUser删掉
  belongs_to :tag, :class_name => "WenbaTag", :foreign_key => "ask_expert"
  has_many :decoration_diaries,:foreign_key => "user_id"
  has_many :deco_firm_remarks, :class_name => "Remark", :conditions=>"source_type='DecoFirm'"
  has_many :remarks
  has_many :comments, :class_name => "ProductComment", :foreign_key => "user_id"
  has_one :deco_firm, :class_name => "DecoFirm"
  has_many :wenba_topics,:class_name => "AskZhidaoTopic", :foreign_key => "user_id", :conditions => "is_delete = 0"
  has_many :all_wenba_topics, :class_name => "AskZhidaoTopic", :foreign_key => "user_id"

  def self.authenticate(name, password)
    HejiaUserBbs.find(:first, :select => "userbbsid, deco_id, freeze_date,LOGINDATE",
      :conditions => ["username = ? and userspassword = ?", name, md5(password)])
  end

  def id
    read_attribute(:USERBBSID) || read_attribute(:userbbsid) # 可悲的是，有的查询直接写了select userbbsid，所以这两个名字会有的地方用这个，有的地方用那个。。。OTZ
  end

#insert into wenba_users(user_id,name,regist_time,ip_address) SELECT USERBBSID,USERNAME,CREATTIME,LOGINIP FROM HEJIA_USER_BBS
  def create_wenba_user
    BokeUser.create(:user_id => self.USERBBSID,:name => self.USERNAME, :regist_time => self.CREATTIME, :ip_address => self.LOGINIP)
  end

  def create_boke_user
    WenbaUser.create(:user_id => self.USERBBSID,:name => self.USERNAME, :regist_time => self.CREATTIME, :ip_address => self.LOGINIP)
  end

  private
  def self.md5(password)
    Digest::MD5.hexdigest(password)
  end
end
