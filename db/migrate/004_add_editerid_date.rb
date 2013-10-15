class AddEditeridDate < ActiveRecord::Migration
  def self.up
    down
    editers = Bbsuser.find_by_sql("SELECT B.USERBBSID as USERBBSID,B.USERNAME as USERNAME,B.USERBBSNAME as USERBBSNAME FROM HEJIA_USER_BBS B,HEJIA_USER_ROLE R WHERE B.USERBBSID = R.USER_ID AND R.ROLE_ID=3 AND B.USERBBSNAME IS NOT NULL ")
    editers.each do |editer|
      temp = User.new
      temp.name = editer.USERNAME+"_bbs"
      temp.password = '51hejia'
      temp.rname = editer.USERBBSNAME
      temp.role = 999
      temp.idate = Time.mktime(2012,3,15)
      temp.editer_id = editer.USERBBSID
      temp.save
    end
  end

  def self.down
    User.delete_all "role=999"
  end
end
