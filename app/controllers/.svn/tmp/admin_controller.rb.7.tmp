class AdminController < ApplicationController

  before_filter :user_validate, :except => [:validate_authority, :index]   #验证用户身份

  def index
    if request.env["HTTP_HOST"].to_s == "member.51hejia.com"
      redirect_to "/member/"
    else
      user_validate
      # 用户验证失败的话，performed?会返回true
      unless performed?
        redirect_to "/user/login?signout=true" unless staff_logged_in?
      end
    end
  end

  def products
    need_inneruser
  end

  def change_password_save   
    if pp(params[:old_pw])&&pp(params[:password1])
      if current_staff.pw_md5 == Digest::MD5.hexdigest(params[:old_pw])
        begin
          current_staff.pw_md5 = Digest::MD5.hexdigest(params[:password1])
          current_staff.save
          render :text => alert("操作成功：用户密码已修改!") + js(top_load("self"))
        rescue Exception => e
          render :text => alert_error("操作失败：#{get_error(e)}")
        end
      else
        render :text => alert_error("操作失败：原密码错误!")
      end
    end
  end

  ## update by dingchunlai 2013-06-28
  ## 外部访问密码为：ruby&php!
  def validate_authority
    if opw = params[:opw]
      if Digest::MD5.hexdigest(opw) == "9a68692e1ddcc4d497fdf3fd70abebab"
        session[:allow_outer_access] = true
        redirect_to "/admin/index"
      else
        @notice = "密码错误，请重新输入！"
        render :layout => false
      end
    else
      @notice = "请输入外部访问密码！"
      render :layout => false
    end
  end

end
