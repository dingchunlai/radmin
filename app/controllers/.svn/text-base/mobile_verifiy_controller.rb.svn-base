class MobileVerifiyController < ApplicationController
  layout  "review"

  def index

  end

  def update
    if params[:mobile_verifies] && params[:commit]
      if params[:mobile_verifies].size == 11 && params[:mobile_verifies] == params[:mobile_verifies].to_i.to_s
        user_ids = HejiaUserBbs.find(:all, :conditions => ["USERBBSMOBELTELEPHONE=?", params[:mobile_verifies]]).map(&:USERBBSID)
      else
        user_ids = HejiaUserBbs.find(:all, :conditions => ["USERNAME in (?)", params[:mobile_verifies].split("\r\n")]).map(&:USERBBSID)
      end
      ids = '0'
      user_ids.each do |id|
        ids = ids + ','+ id.to_s
      end
      HejiaUserBbs.update_all("mobile_verified='1'", "USERBBSID in (#{ids})") if params[:commit] == "验证"
      HejiaUserBbs.update_all("mobile_verified='0'", "USERBBSID in (#{ids})") if params[:commit] == "取消验证"
      flash[:notice] = "操作已成功"
    end
    redirect_back
  end
  
end
