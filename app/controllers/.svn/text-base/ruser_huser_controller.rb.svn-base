class RuserHuserController < ApplicationController

  before_filter :user_validate

  #BBS displays 
  #the current logged-on user 
  #with the user information corresponding to
  def index
    index_message(params[:err],params[:succ],params[:reset])
    @rhuser = RuserHuser.find(:all,:conditions => ["ruser_id = ?", current_staff.id] ,:order => "id desc")
    @alluser = User.find(:all, :select => "id, rname", :order => "id desc")
  end

  #AJAX Asynchronous extract data 
  #(data elements that match the user name-BBSUSERNAME)
  def select_buser
    @bbs_name = nil
    bname = params[:bname].to_s
    @bbs_name = HejiaUserBbs.find(:all, :select => "USERBBSID,USERNAME", :conditions => "USERNAME like '%#{bname}%'")
    render :partial => "show_bbs_name"
  end

  #User Binding Operation
  def user_binding
    err_name = ""
    succ_name = ""
    re_name = ""
    rid = params[:ru_name]
    users = User.find(rid.to_s)
    bname = params[:bu_name].to_s
    bnames = bname.split(";")
    for bs in bnames
      bbs_name = HejiaUserBbs.find(:first, :select => "USERBBSID,USERNAME", :conditions => "USERNAME = '#{bs}'")
      if bbs_name.nil?
        err_name += "| "+bs.to_s+" |" 
      else
        rhu = RuserHuser.find(:first, :select => "id", :conditions => ["huser_id = ?",bbs_name.USERBBSID])
        if rhu.nil?
          r_h_user = RuserHuser.new
          r_h_user.ruser_id = users.id
          r_h_user.huser_id = bbs_name.USERBBSID
          r_h_user.save
          succ_name += "| "+bs.to_s+" |" 
        else
          re_name += "| "+bs.to_s+" |" 
        end
      end
    end
    @error_name = "错误BBS用户名:" + err_name
    @success_name = "成功绑定BBS用户名:" + succ_name
    @reset_name = "已被绑定过的BBS用户名:" + re_name
    redirect_to  :action => "index", :err => @error_name, :succ => @success_name, :reset => @reset_name
  end

  #No binding information according to delete a user
  def delete_rhuser
    RuserHuser.delete(params[:id].to_s)
    redirect_to :action => "index"
  end

  private

  def index_message(err,succ,reset)
    if params[:err]
        if params[:err].to_s == "错误BBS用户名:"
          @error_nam = nil
        else
          @error_nam = params[:err].to_s
        end
    end
    if params[:succ]
        if params[:succ].to_s == "成功绑定BBS用户名:"
          @succ_nam = nil
        else
          @succ_nam = params[:succ].to_s
        end
    end
    if params[:reset]
        if params[:reset].to_s == "已被绑定过的BBS用户名:"
          @reset_nam = nil
        else
          @reset_nam = params[:reset].to_s
        end
    end
  end
end
