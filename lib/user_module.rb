module UserModule

  protected

  # 本文件包含用户相关方法
  def user_validate
    if staff_logged_in?
      # 验证外网用户访问权限
      validate_access_authority
    else
      show_validate_error("您还未登录！")
      return false
    end
  end

  # 验证外网用户访问权限
  def validate_access_authority
    redirect_to :controller => 'admin', :action => 'validate_authority' if session[:allow_outer_access] != true &&
      request.remote_ip != "58.246.26.58" &&
      RAILS_ENV != 'development'
  end

  # 权限验证
  def pvalidate(operate, *roles)
    if roles.empty? || staff_logged_in? && roles.any? { |role| current_staff.member_of? role }
      true
    else
      show_validate_error("只有【#{roles.join("、")}】才能执行【#{operate}】操作，您不具备这样的权限。")
      false
    end
  end

  def check_login(name, password_md5, keeplogin) #登录验证
    require 'md5'
    err_info = ""
    #执行登录验证
    user = User.find :first, :select=>"id, name, month_login_num, department, login_num, last_login, pw_md5, role, idate", :conditions=>["name='#{name}'"]
      
    if user.nil?
      err_info = "用户名不存在"
    elsif user.pw_md5 !=password_md5
      err_info = "密码错误"
    elsif user.idate < Time.now
      err_info = "用户账号已失效"
    else
      #登录验证成功
      session['user:staff:id'] = user.id
      cookies['ind_id'] = {:value => user.id.to_s, :domain => '.51hejia.com'}

      # 为了兼容PHP的做法。
      cookies['radmin_id'] = {:value => user.id.to_s, :domain => '.51hejia.com', :expires => 1.month.from_now}
      cookies['radmin_user'] = {:value => user.name.to_s, :domain => '.51hejia.com', :expires => 1.month.from_now}

      UserLogin.record_user_login(user.id) #记录用户登录行为，一个用户每天只记录一次。

      user.month_login_num = UserLogin.get_month_login_num(user.id) #取得用户一个月内的登录次数
      user.login_num = user.login_num + 1
      user.last_login = getnow()
      user.save
    end
    return err_info #返回错误信息，如果是空字符串代表登录成功!
  end

  def show_validate_error(str) #输出验证错误
    if (request.request_uri=="/" || request.request_uri=="/admin")
      render :text => js(top_load("/user/login"))
    else
      render :text => "<div style='line-height:30px; padding:30px'><b>#{str} <a href=\"/user/login\">[点这里登录]</a></b>\
  <br /><br />如果您是因长时间未访问页面而使登录信息失效的话，\
  请 <a href=\"/user/login\" target=\"_blank\">点这里在新窗口中登录</a> ,<br />\
  然后 <a href=\"#\" onclick=\"location.reload();\">点这里刷新本页面</a> 以完成您的操作。<br /><br />\
  或者您也可以 <a href=\"#\" onclick=\"history.back();\">点这里返回前一页</a> 。</div>" + js("if (top!=self) alert(\"#{str}\");")
    end
  end

  def isrole(name)
    staff_logged_in? and current_staff.member_of?(name)
  end

end
