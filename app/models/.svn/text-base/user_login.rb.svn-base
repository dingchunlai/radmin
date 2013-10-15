# == Schema Information
#
# Table name: radmin_user_logins
#
#  id         :integer(11)     not null, primary key
#  user_id    :integer(11)     not null
#  login_date :integer(11)     not null
#  created_at :datetime        not null
#

class UserLogin < ActiveRecord::Base

  self.table_name = "radmin_user_logins"

  def self.record_user_login(user_id) #记录用户登录行为，一个用户每天只记录一次。
      if user_id.to_i > 0
        UserLogin.create(:user_id => user_id.to_i, :login_date => Time.now.strftime("%Y%m%d")) rescue nil
      end
  end

  def self.get_month_login_num(user_id) #取得用户一个月内的登录次数
    if user_id.to_i > 0
      return UserLogin.count("id", :conditions => "user_id = #{user_id.to_i} and created_at > adddate(now(), interval -30 day)")
    else
      return 0
    end
  end
end
