class UserController < ApplicationController

  helper Hejia::SessionStore::Helpers

  before_filter :user_validate, :except => [:send_mobile_code,:verify_mobile_code,:login, :hlogin, :get_image_code,:do_modify_pw_091117] #验证用户身份

  def get_image_code
    validate_image = ValidateImage.new(4)
    session[:image_code] = validate_image.code
    send_data(validate_image.code_image, :type => 'image/jpeg')
  end

  # 发送手机验证码
  def send_mobile_code
    mobile = params[:mobile]

    mobile_key = "mobile_code:mobile:#{mobile}"
    user_key   = "mobile_code:user:#{current_user.USERBBSID}"

    if HejiaUserBbs.find(:first,:select=>"USERBBSID",:conditions=>["USERBBSMOBELTELEPHONE = ? and mobile_verified = 1" , mobile]) #判断手机 是否绑定过
      render :json => "提示: 当前输入的手机号已经被其它帐号绑定，请更换号码后重新获得验证码"
    elsif REDIS_DB.get(mobile_key) #手机没通过验证
      logger.info "[Mobile] | #{mobile} | phone 3 miniutes limit hits!"
      render :json => "提示：此手机号码三分钟之内只能验证一次"
    elsif REDIS_DB.get(user_key)  #用户没通过验证
      logger.info "[Mobile] #{current_user.USERBBSID} | user 3 miniutes limit hits!"
      render :json => "提示：您在三分钟之内只能验证一次"
    else
      code = rand(8999) + 1000

      verify_code = MobileCodeVerify.new
      verify_code.user_id = current_user.USERBBSID
      verify_code.user_mobile = mobile
      verify_code.resource_type = "DecorationDiary"
      verify_code.verify_code = code
      verify_code.verify_status = false
      #判断是否是重发的
      first_verify_code = MobileCodeVerify.find(:first, :conditions => ["user_id=? and user_mobile=?", current_user.USERBBSID, mobile], :order => 'id desc')
      if first_verify_code && first_verify_code.created_at + 900 > Time.now
        a = ",您上次收到的验证码将自动失效.【和家网】"
      else
        a=".【和家网】"
      end
      #Hejia::SMS.send_text_message("您的验证码是#{code},请在15分钟内使用" + a, mobile) === true
      if Hejia::SMS::Backends::Eachwe.send_text_message("您的验证码是#{code},请在15分钟内使用" + a, mobile) === true
        logger.info "[Mobile] | #{mobile} | #{current_user.USERBBSID} | set limit!"
        REDIS_DB.setex mobile_key, 3.minutes, 1
        REDIS_DB.setex user_key,   3.minutes, 1
        REDIS_DB.setex mobile_auth_code_key, 15.minutes, code
        verify_code.send_status = true
        render :json => "success"
      else
        verify_code.send_status = false
        render :json => "短信发送失败"
      end
      verify_code.save
    end
  end

  def verify_mobile_code
    code = params[:code]
    mobile = params[:mobile]
    verify_code = MobileCodeVerify.find(:first, :conditions => ["user_id=? and user_mobile=? and verify_code=?", current_user.USERBBSID, mobile, code])
    if REDIS_DB.get(mobile_auth_code_key) == code
      REDIS_DB.del mobile_auth_code_key
      HejiaUserBbs.update_all("mobile_verified = 1 , USERBBSMOBELTELEPHONE = #{mobile} ",:USERBBSID => current_user.USERBBSID)
      verify_code.update_attribute(:verify_status, true)
      render :json => "1"
    else
      verify_code.update_attribute(:verify_status, false)
      render :json => "0"
    end
  end

  def hlogin
    if pp(params[:signout])  #执行注销登录操作
      logout
      redirect_to "/bin/login.html"
    elsif params[:username].nil? #转向登录界面
      render :layout => false
    else  #接受登录数据
      require 'md5'
      username = params[:username]
      password_md5 = Digest::MD5.hexdigest(strip(params[:password].to_s))
      if params[:keeplogin] == "true"
        keeplogin = true
      else
        keeplogin = false
      end
      #开始执行登录操作
      return_value = check_login(username, password_md5, keeplogin)
      if return_value ==""
        #通过登录验证
        if session[:rurl].nil?
          rurl ="/"
        else
          rurl = session[:rurl]
          session[:rurl] = nil
        end
        render :text => js(top_load(rurl))
      else
        #未通过登录验证
        render :text => alert("登录失败：#{return_value}")
      end
    end
  end

  def list
    return false unless pvalidate("浏览用户列表")
    @keyword = params[:keyword]
    @role = params[:role]
    @state = params[:state]
    conditions = []
    conditions << "(name like '%#{@keyword}%' or rname like '%#{@keyword}%')" unless @keyword.nil?
    conditions << "role like '%#{@role}%'" unless @role.nil?
    if !@state.nil?&&@state.to_s!=''
      conditions << "state = #{@state}"
    end
    @users = paging_record options = {
      "model" => User,
      "pagesize" => 16,   #每页记录数
      "listsize" => 10,  #同时显示的页码数
      "select" => "id, name, rname, department, login_num, last_login, cdate, udate, idate, role,state",
      "conditions" => conditions.join(" and "),
      "order" => "udate desc"
    }
  end

  def new #添加记录
    return false unless pvalidate("添加新用户","管理员","后台维护")
    @idate = dateadd(Time.now, 3650)
    @roles = "116" #选中的角色
    @edit_role = User.find(:all, :select => "id,rname")
    @parent_id = 0
  end

  def new_save
    return false unless pvalidate("保存添加新用户","管理员","后台维护")
    begin
      user = User.new
      user.name = strip(params[:name1].to_s)
      user.pw_md5 = Digest::MD5.hexdigest(strip(params[:password1].to_s))
      user.role = params[:role].join(",")
      user.idate = strip(params[:idate1].to_s)
      user.rname = strip(params[:rname].to_s)
      user.department = params[:department].to_i
      user.description = strip(params[:description].to_s) if pp(params[:description])
      user.parent_id = params[:r_manager].to_s if params[:r_manager] && params[:r_manager].to_s != 0
      user.cdate = Time.now
      user.udate = Time.now
      user.save
      render :text => alert("操作成功：新用户已创建!") + js(top_load("self"))
    rescue Exception => e
      render :text => alert_error("操作失败：#{get_error(e)}")
    end
  end

  def edit
    return false unless pvalidate("编辑用户信息","管理员","后台维护")
    @user = User.find(params[:id])
    @parent_id = User.find(:first, :conditions => ["id = ?", params[:id]]).parent_id.to_s
    @roles = @user.role #选中的角色
    @department = @user.department
    @edit_role = User.find(:all, :select => "id,rname")
  end

  def edit_save
    return false unless pvalidate("保存编辑用户信息","管理员","后台维护")
    begin
      user = User.find(params[:id1].to_i)
      user.name = strip(params[:name1].to_s)
      user.pw_md5 = Digest::MD5.hexdigest(strip(params[:password1].to_s)) unless strip(params[:password1].to_s)=="********"
      user.role = params[:role].join(",")
      user.idate = strip(params[:idate1].to_s)
      puts strip(params[:rname].to_s)
      user.rname = strip(params[:rname].to_s)
      user.department = params[:department].to_i
      user.description = strip(params[:description].to_s) if pp(params[:description])
      user.parent_id = params[:r_manager].to_s if params[:r_manager] && params[:r_manager].to_s != 0
      user.udate = Time.now
      user.save
      render :text => alert("操作成功：用户信息已保存！") + js(top_load("self"))
    rescue Exception => e
      render :text => alert_error("操作失败：#{get_error(e)}")
    end
  end

  def del
    return false unless pvalidate("删除用户记录","管理员")
    begin
      User.delete(params[:id]) unless params[:id].nil?
      User.delete_all "id in (#{params[:ids]})" unless params[:ids].nil?
      render :text => js(top_load("self"))
    rescue Exception => e
      render :text => alert_error("操作失败：#{get_error(e)}")
    end
  end

  def stop
    return false unless pvalidate("禁用用户记录","管理员")
    begin
      User.update(params[:id],{:idate=>Time.now,:state=>1}) unless params[:id].nil?
      render :text => js(top_load("self"))
    rescue Exception => e
      render :text => alert_error("操作失败：#{get_error(e)}")
    end
  end

  def start
    return false unless pvalidate("启用用户记录","管理员")
    begin
      User.update(params[:id],{:idate=>strip("2019-01-01"),:state=>0}) unless params[:id].nil?
      render :text => js(top_load("self"))
    rescue Exception => e
      render :text => alert_error("操作失败：#{get_error(e)}")
    end
  end

  def login
    if pp(params[:signout])  #执行注销登录操作
      logout
      session[:allow_outer_access] = false
      redirect_to "/bin/login.html"
    elsif params[:username].nil? #转向登录界面
      redirect_to "/bin/login.html"
    else  #接受登录数据
      require 'md5'
      username = params[:username]
      password_md5 = Digest::MD5.hexdigest(strip(params[:password].to_s))
      if params[:keeplogin] == "true"
        keeplogin = true
      else
        keeplogin = false
      end
      #开始执行登录操作
      return_value = check_login(username, password_md5, keeplogin)
      if return_value ==""
        #通过登录验证
        if session[:rurl].nil?
          rurl ="/"
        else
          rurl = session[:rurl]
          session[:rurl] = nil
        end
        render :text => rurl
      else
        #未通过登录验证
        render :text => "登录失败：#{return_value}"
      end
    end
  end

  private

  def logout
    logout_staff!
    session[:allow_outer_access] = false
  end

  def mobile_auth_code_key
    "mobile_code:#{current_user.USERBBSID}"
  end

end

