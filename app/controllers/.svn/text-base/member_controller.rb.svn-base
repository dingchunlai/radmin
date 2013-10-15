class MemberController < ApplicationController

  # action太多了，应该整理为使用except
  before_filter :member_validate, :only => [
    :note_list, :note_send_list, :note_send, :note_send_save, :note_receiver_del, :note_sender_del,
    :userask, :useralbum, :userask_del, :usertopic, :usertopic_del, :userpw, :userpw_save, :userinfo,
    :userinfo_save, :usercollections, :dianping_list, :reply_list
  ]
  
  uses_tiny_mce :options => {
    :language => 'zh',
    :theme => 'advanced',
    #:width => "760px",
    :convert_urls => false,
    :relative_urls => false,
    :visual => false,
    :theme_advanced_buttons1 => "bold,italic,underline,strikethrough,|,justifyleft,justifycenter,justifyright,justifyfull,|,bullist,numlist,|,formatselect,fontselect,fontsizeselect,|,outdent,indent,blockquote,|,undo,redo",
    :theme_advanced_buttons2 => "tablecontrols,|,hr,removeformat,visualaid,code |,hr,removeformat,visualaid,|,link,unlink,anchor,image,upload,cleanup,|,forecolor,backcolor,code",
    :theme_advanced_buttons3 => "",
    :theme_advanced_resizing => false,
    :theme_advanced_resize_horizontal => false,
    :theme_advanced_toolbar_location => "top",
    :theme_advanced_toolbar_align => "left",
    :theme_advanced_statusbar_location => "bottom",
    :plugins => %w{ table fullscreen upload}
  }#,:only => [:new, :create, :edit, :update]
  $formid=PINGLUN_ID
  $replyid=88
  def my_notes
    new_receiver_ids = CACHE.get("new_receiver_ids")
    new_receiver_ids = Array.new if new_receiver_ids.nil?
    @have_new_note = new_receiver_ids.find_all{|x| x== current_user.id }.length
    render :layout => false
  end
  
  def note_list #站内短信收件箱
    h = Hash.new
    h["model"] = Note
    h["pagesize"] = 14 #每页记录数
    h["listsize"] = 10 #同时显示的页码数
    h["select"] = "id,sender_id,receiver_id,content,created_at,is_read,sender_del,receiver_del"
    h["conditions"] = "receiver_del = 0 and receiver_id = #{current_user.id}"
    h["order"] = "id desc"
    @notes = paging_record(h)
    note_ids = ""
    sender_ids = ""
    for note in @notes
      note_ids += (","+note.id.to_s)
      sender_ids += (","+note.sender_id.to_s)
    end
    Note.update_all("is_read=1", "id in (#{filter_first_letter(note_ids,",")})") if note_ids != ""#将列出的短信设为已阅读状态
    modify_new_receiver_ids(current_user.id, 0)
    @sender_name = Hash.new #发件人用户名哈希表
    if sender_ids != ""
      users = HejiaUserBbs.find(:all,:select=>"USERBBSID, USERNAME",:conditions=>"USERBBSID in (#{filter_first_letter(sender_ids, ",")})")
      for user in users
        @sender_name[user.USERBBSID] = user.USERNAME
      end
    end
  end
  
  def note_send_list #站内短信收件箱
    h = Hash.new
    h["model"] = Note
    h["pagesize"] = 14 #每页记录数
    h["listsize"] = 10 #同时显示的页码数
    h["select"] = "id,sender_id,receiver_id,content,created_at,is_read,sender_del,receiver_del"
    h["conditions"] = "sender_del = 0 and sender_id = #{current_user.id}"
    h["order"] = "id desc"
    @notes = paging_record(h)
    receiver_ids = ""
    for note in @notes
      receiver_ids += (","+note.receiver_id.to_s)
    end
    
    @receiver_name = Hash.new #发件人用户名哈希表
    if receiver_ids != ""
      users = HejiaUserBbs.find(:all,:select=>"USERBBSID, USERNAME",:conditions=>"USERBBSID in (#{filter_first_letter(receiver_ids, ",")})")
      for user in users
        @receiver_name[user.USERBBSID] = user.USERNAME
      end
    end
  end
  
  def note_send
    @receiver = params[:receiver]
    render :layout => false
  end
  
  def note_send_save
    receiver = trim(params[:receiver])
    content = trim(params[:content])
    if pp(content) && pp(receiver)
      user = HejiaUserBbs.find(:first,:select=>"USERBBSID,USERNAME",:conditions=>"USERNAME='#{receiver}'")
      if user.nil?
        rt = alert("发送失败：用户名不存在!")
      else
        begin
          note = Note.new
          note.sender_id = current_user.id
          note.receiver_id = user.USERBBSID
          note.content = content
          note.created_at = getnow()
          note.save
          modify_new_receiver_ids(user.USERBBSID, 1)
          rt = alert("短信发送成功!") + js("top.Loading.style.display='none';")
        rescue Exception => e
          rt = alert_error("操作失败：#{get_error(e)}")
        end
      end
    else
      rt = alert("短信内容必须填写!")
    end
    render :text => rt + js("parent.document.getElementById('submit_button').disabled = false;")
  end
  
  def modify_new_receiver_ids(user_id, operate)
    new_receiver_ids = CACHE.get("new_receiver_ids")
    new_receiver_ids = Array.new if new_receiver_ids.nil?
    if operate == 1
      new_receiver_ids << user_id.to_i
    else
      new_receiver_ids = new_receiver_ids.reject{|x| x==user_id.to_i}
    end
    CACHE.set("new_receiver_ids", new_receiver_ids)
  end
  
  def note_receiver_del
    begin
      Note.update_all("receiver_del=1", "id = #{params[:id]}") unless params[:id].nil?
      Note.update_all("receiver_del=1", "id in (#{params[:ids]})") unless params[:ids].nil?
      render :text => js(top_load("self"))
    rescue Exception => e
      render :text => alert_error("操作失败：#{get_error(e)}")
    end
  end
  
  def note_sender_del
    begin
      Note.update_all("sender_del=1", "id = #{params[:id]}") unless params[:id].nil?
      Note.update_all("sender_del=1", "id in (#{params[:ids]})") unless params[:ids].nil?
      render :text => js(top_load("self"))
    rescue Exception => e
      render :text => alert_error("操作失败：#{get_error(e)}")
    end
  end
  
  def userask
    @user_id = current_user.id
    @username = current_user.USERNAME
    @pagesize = 12 #每页记录数
    @listsize = 10 #同时显示的页码数
    cd = "true"
    cd += " and area_id = 1 and is_delete = 0 and user_id = #{@user_id}"
    if params[:page].nil?
      @curpage = 1
    else
      @curpage = params[:page].to_i
    end
    if params[:recordcount].nil?
      @recordcount = AskZhidaoTopic.count("id", :conditions => cd)
    else
      @recordcount = params[:recordcount].to_i
    end
    @pagecount = (1.0 * @recordcount / @pagesize).ceil
    
    @topics = AskZhidaoTopic.find :all,
      :select => "id, subject, tag_id, view_counter, post_counter, user_id, created_at, updated_at",
      :conditions => cd,
      :order => 'id desc',
      :offset => @pagesize * (@curpage - 1),
      :limit => @pagesize
  end
  
  def useralbum
    @user_id = current_user.id
    @username = current_user.USERNAME
    @pagesize = 12 #每页记录数
    @listsize = 10 #同时显示的页码数
    cd = "true"
    cd += " and area_id = 1 and is_delete = 0 and user_id = #{@user_id}"
    if params[:page].nil?
      @curpage = 1
    else
      @curpage = params[:page].to_i
    end
    if params[:recordcount].nil?
      @recordcount = AskZhidaoTopic.count("id", :conditions => cd)
    else
      @recordcount = params[:recordcount].to_i
    end
    @pagecount = (1.0 * @recordcount / @pagesize).ceil
    
    @topics = AskZhidaoTopic.find :all,
      :select => "id, subject, tag_id, view_counter, post_counter, user_id, created_at, updated_at",
      :conditions => cd,
      :order => 'id desc',
      :offset => @pagesize * (@curpage - 1),
      :limit => @pagesize
  end
  
  def userask_del
    begin
      AskZhidaoTopic.update_all("is_delete = 1","id in (#{params[:ids]}) and user_id = #{current_user.id}") unless params[:ids].nil?
      render :text => js(top_load("self"))
    rescue Exception => e
      render :text => alert_error("操作失败：#{get_error(e)}")
    end
  end
  
  def usertopic
    @user_id = current_user.id
    @username = current_user.USERNAME
    @pagesize = 12 #每页记录数
    @listsize = 10 #同时显示的页码数
    cd = "true"
    cd += " and area_id = 1 and is_delete = 0 and user_id = #{@user_id}"
    if params[:page].nil?
      @curpage = 1
    else
      @curpage = params[:page].to_i
    end
    if params[:recordcount].nil?
      @recordcount = BbsTopic.count("id", :conditions => cd)
    else
      @recordcount = params[:recordcount].to_i
    end
    @pagecount = (1.0 * @recordcount / @pagesize).ceil
    
    @topics = BbsTopic.find :all,
      :select => "id, subject, tag_id, view_counter, post_counter, user_id, created_at, updated_at, username, latest_reply_userinfo, is_top, is_good, latest_reply_at",
      :conditions => cd,
      :order => 'id desc',
      :offset => @pagesize * (@curpage - 1),
      :limit => @pagesize
  end
  
  def usertopic_del
    begin
      BbsTopic.update_all("is_delete = 1","id in (#{params[:ids]}) and user_id = #{current_user.id}") unless params[:ids].nil?
      render :text => js(top_load("self"))
    rescue Exception => e
      render :text => alert_error("操作失败：#{get_error(e)}")
    end
  end
  
  def userlogin
    render :layout => false
  end
  
  def login_small_win
    render :layout => false
  end
  
  def ulogin
    render :layout => false
  end
  
  def get_password
    #render :layout => false
  end
  
  def get_password_send_mail(rv="",forward=nil)
    username = trim(params[:username])
    rv="参数不足：请输入用户名！" unless pp(username)
    if rv == ""
      user = HejiaUserBbs.find_by_USERNAME(username,:select=>"USERBBSID,USERSPASSWORD,USERBBSEMAIL")
      if user.nil?
        rv = "操作失败：该用户名不存在！"
      else
        if pp(user.USERBBSEMAIL)
          new_pw = (rand(800000)+100000).to_s
          HejiaUserBbs.update_all(["USERSPASSWORD = ?", md5(new_pw)], ["USERBBSID = ?", user.USERBBSID])
          SentMail.deliver_sent("和家网会员密码重置通知","您的和家会员新密码为：#{new_pw}",user.USERBBSEMAIL)
          rv = "操作成功：新密码已发送到您的安全信箱内，请查收。"
          forward = "http://www.51hejia.com"
        else
          rv = "无法发送密码，您没有填写安全信箱！"
        end
      end
    end
    rv = alert(rv) unless rv==""
    rv += js("window.open('#{forward}','_top');") unless forward == nil
    render :text => rv
  end
  
  def userpw
    @user_id = current_user.id
    @username = current_user.USERNAME
  end
  
  def userpw_save
    if pp(params[:old_pw])&&pp(params[:password1])
      if trim(current_user.USERSPASSWORD.to_s)==trim(HejiaUserBbs.md5(params[:old_pw]))
        begin
          HejiaUserBbs.update(current_user.id, :USERSPASSWORD => trim(HejiaUserBbs.md5(params[:password1])))
          render :text => alert("操作成功：用户密码已修改!")# + js(top_load("self"))
        rescue Exception => e
          render :text => alert_error("操作失败：#{get_error(e)}")
        end
      else
        render :text => alert_error("操作失败：原密码错误!") + js("top.ge('old_pw').select();")
      end
    end
  end

  ## bbs论坛修改密码接口
  def bbs_userpw_save
    
  end
  
  def userinfo
    @headimg = current_user.HEADIMG
    @user_id = current_user.id
    @username = current_user.USERNAME
    @userbbsname = iconv(current_user.USERBBSNAME)
    @userbbstel = iconv(current_user.USERBBSTEL)
    @userbbssex = iconv(current_user.USERBBSSEX)
    @userbbsaddress = iconv(current_user.USERBBSADDRESS)
    @userbbsreadme = iconv(current_user.USERBBSREADME)
    @area = iconv(current_user.AREA)
    @city = iconv(current_user.CITY)
    @msn = iconv(current_user.MSN)
    @qq = iconv(current_user.QQ)
    #@firm = DecoFirm.find current_deco_id if current_deco_id > 0
    redirect_to "http://zxgs.51hejia.com" if current_deco_id > 0
  end
  
  def userinfo_save
    userbbsname = iconv(trim(params[:userbbsname]))
    userbbstel = iconv(trim(params[:userbbstel]))
    userbbssex = iconv(trim(params[:userbbssex]))
    userbbsaddress = iconv(trim(params[:userbbsaddress]))
    userbbsreadme = iconv(params[:userbbsreadme])
    area = iconv(trim(params[:area]))
    city = iconv(trim(params[:city]))
    msn = iconv(trim(params[:msn]))
    qq = iconv(trim(params[:qq]))
    
    filename = get_file(params[:headimg_upload], "/uploads/headimg/")
    if filename.nil?
      headimg = trim(params[:headimg])
    else
      headimg = "http://#{request.env["HTTP_HOST"]}/uploads/headimg/#{filename}"
    end
    
    begin
      current_user.USERBBSNAME = userbbsname if pp(userbbsname)
      current_user.USERBBSTEL = userbbstel if pp(userbbstel)
      current_user.USERBBSSEX = userbbssex if pp(userbbssex)
      current_user.USERBBSADDRESS = userbbsaddress
      #current_user.USERBBSREADME = userbbsreadme #世博期间暂停修改用户签名功能
      current_user.AREA = area if pp(area)
      current_user.CITY = city if pp(city)
      current_user.MSN = msn
      current_user.QQ = qq
      current_user.HEADIMG = headimg if pp(headimg)
      current_user.save
      render :text => alert("操作成功：您填写的资料已保存！") + js(top_load("/member/userinfo?clean=t"))
    rescue Exception => e
      render :text => alert_error("操作失败：#{get_error(e)}")
    end
  end
  
  def reg
    if user_logged_in?
      redirect_to :action => "userinfo"
      return false
    end
    session[:forward] = trim(params[:forward])
    render :layout => false
  end
  
  def reg_small_win
    session[:forward] = trim(params[:forward])
    render :layout => false
  end
  
  def expert_reg
    @lv2_tags = WenbaTag.find(:all,:select=>"id, name",:conditions=>"parent_id in (1,38,173)")
    session[:forward] = trim(params[:forward])
    render :layout => false
  end
  
  def ind_user_reg_save(rv="",ru=nil)
    username = trim(params[:username])
    email = trim(params[:userbbsemail])
    return render :text => alert("验证码错误，请重新填写！") if params[:image_code].blank? || params[:image_code].to_s.strip != session[:image_code]
    rv = "用户名太短！" if username.length < 3
    rv = "邮箱格式不正确！" if email.length < 3
    if rv == ""
      repair_enjoy = ""
      repair_enjoy += params[:repairEnjoy1]+"," if pp(params[:repairEnjoy1])
      repair_enjoy += params[:repairEnjoy2]+"," if pp(params[:repairEnjoy2])
      repair_enjoy += params[:repairEnjoy3]+"," if pp(params[:repairEnjoy3])
      begin
        HejiaUserBbs.create(
          :USERNAME => iconv(username),
          :USERBBSEMAIL => email,
          :BBSID => Time.now.strftime("%Y_%m_%d_%H_%M_%S"),
          :USERTYPE => 1,
          :USERBBSSEX => iconv(params[:gender]),
          :AREA => trim(params[:area]),
          :CITY => trim(params[:city]),
          :USERSPASSWORD => HejiaUserBbs.md5(trim(params[:userpassword])),
          :CREATTIME => getnow(),
          :LOGINDATE => getnow(),
          :HEADIMG => "http://member.51hejia.com/images/headimg/default.gif",
          :ask_expert => 0,
          :USERBBSTEL => trim(params[:userBbsTel]),
          :REPAIRENJOY => iconv(repair_enjoy),
          :REPAIRTYPE => iconv(trim(params[:repairType])),
          :REPAIRTIME => iconv(trim(params[:repairTime]))
        )
        rv = "用户注册成功！"
        session[:image_code] = nil
        if pp(params[:forward])
          forward = params[:forward]
        else
          forward = session[:forward].to_s
          session[:forward] = nil
        end
        forward = "http://www.51hejia.com" if forward == "" || forward == "http://"
        ru = forward
      rescue Exception => e
        if e.to_s.include?("Duplicate entry")
          rv = "注册失败：已存在相同的用户名，请修改后重新提交！"
        else
          rv = "注册失败：系统在保存信息的遇到错误(#{e})！"
        end
      end
    end
    myrender(rv,ru)
  end
  
  def reg_save
    return false if params[:username].blank? || params[:userbbsemail].blank?
    ask_expert = params[:ask_expert].to_i
    if ask_expert == 0
      return render :text => alert("验证码错误，请重新填写！") if params[:image_code].blank? || params[:image_code].to_s.strip != session[:image_code]
    end
    begin
      hub = HejiaUserBbs.new
      hub.USERNAME = trim(params[:username])
      hub.USERBBSEMAIL = trim(params[:userbbsemail])
      hub.BBSID = Time.now.strftime("%Y_%m_%d_%H_%M_%S")
      hub.USERTYPE = 1
      hub.concerned_paint = trim(params[:concerned_paint])
      hub.USERBBSSEX = iconv(params[:gender])
      hub.AREA = trim(params[:area])
      hub.CITY = trim(params[:city])
      hub.USERSPASSWORD = HejiaUserBbs.md5(trim(params[:userpassword]))
      hub.CREATTIME = Time.now
      hub.LOGINDATE = Time.now
      
      if ask_expert > 0
        #专家注册
        hub.HEADIMG = params[:headimg]
        hub.ask_expert = -ask_expert  #负数代表申请中
        hub.USERBBSNAME = iconv(params[:userbbsname])
        hub.USERBBSROLE = iconv(params[:userbbsrole])
        hub.REMARK = params[:remark]
        hub.USERBBSREADME = iconv(params[:userbbsreadme]) if pp(params[:userbbsreadme])
        hub.USERBBSTEL = params[:userbbstel]
        hub.QQ = params[:qq] if pp(params[:qq])
        hub.MSN = params[:msn] if pp(params[:msn])

        hub.save
        login_user! hub
      else
        #普通会员注册
        hub.HEADIMG = "http://member.51hejia.com/images/headimg/default.gif"
        repairEnjoy = ""
        repairEnjoy += params[:repairEnjoy1]+"," if pp(params[:repairEnjoy1])
        repairEnjoy += params[:repairEnjoy2]+"," if pp(params[:repairEnjoy2])
        repairEnjoy += params[:repairEnjoy3]+"," if pp(params[:repairEnjoy3])
        hub.ask_expert = 0
        hub.USERBBSTEL = trim(params[:userBbsTel]) if pp(params[:userBbsTel])
        hub.REPAIRENJOY = iconv(trim(repairEnjoy)) if pp(repairEnjoy)
        hub.REPAIRTYPE = iconv(trim(params[:repairType])) if pp(params[:repairType])
        hub.REPAIRTIME = iconv(trim(params[:repairTime])) if pp(params[:repairTime])
        activity_reg if pp(params[:name])|| pp(params[:mobile]) #注册活动信息

        if !hub.valid?
          @hu.destroy if @hu
          render :text => alert_error("用户注册失败!用户名或邮箱已经存在")
          return false
        else
          ## bbs论坛注册（"1"注册失败，"0"注册成功）
          gender = params[:gender] == "先生" ? "1" : "2"

          req = Net::HTTP::Post.new(URI.parse("http://bbs.51hejia.com/i_ruby2php.php?do=register").path)
          req.set_form_data({"username" => "#{hub.USERNAME}", "password" => "#{trim(params[:userpassword])}", "email" => "#{trim(params[:userbbsemail])}", "gender" => "#{gender}", "authcode" => Digest::MD5.hexdigest("2011081551hejia" + hub.USERNAME + trim(params[:userpassword]))})

          uri = URI.parse("http://bbs.51hejia.com")
          proxy = Net::HTTP::Proxy(uri.host,uri.port)
          http_response = proxy.get_response(URI.parse("http://bbs.51hejia.com/i_ruby2php.php?do=register&#{req.body}"))
          logger.info("http://bbs.51hejia.com/i_ruby2php.php?do=register&#{req.body}")
          logger.info(http_response.body)
          if http_response.body != "status=0"
            @hu.destroy if @hu
            case http_response.body
            when "status=2"
              render :text => alert_error("当前用户名已被注册，请更换用户名")
            when "status=3"
              render :text => alert_error("当前邮箱地址已被注册，请更换邮箱地址")
            else
              render :text => alert_error("同一IP地址在一段时间内无法多次注册")
            end
            return false
          else
            hub.save
            bbs_set_cookie(hub.USERNAME,trim(params[:userpassword]))
            login_user! hub
          end
        end
      end
      if pp(params[:forward])
        forward = params[:forward]
      else
        forward = session[:forward].to_s
        session[:forward] = nil
      end
      forward = "http://www.51hejia.com" if forward == "" || forward == "http://"
      #forward = "http://member.51hejia.com/decoration_diaries/new"
      session[:image_code] = nil
      render :text => alert("用户注册成功!") + js("top.location.href='#{forward}';")
    rescue Exception => e
      render :text => alert("注册失败：用户名或邮箱已经存在。" + e.message.to_s)
    end
    
  end

  
  def check_reg_username()
    username = trim(params[:username].to_s)
    if pp(username)
      hub = HejiaUserBbs.find :first, :select => "userbbsid, username, bbsid", :conditions => ["username = ?", username]
      if hub.nil?
        render :text => js("parent.document.getElementById('reginfo').style.display='block';parent.document.getElementById('reginfo').innerHTML='用户名可以使用!';parent.document.getElementById('reginfo').className='STYLE5'; ")
      else
        render :text => js("parent.document.getElementById('reginfo').style.display='block';parent.document.getElementById('reginfo').innerHTML='用户名已经存在!';parent.document.getElementById('reginfo').className='wrongtips'; ")
      end
    end
  end
  
  def check_username()
    username = trim(params[:username].to_s)
    if pp(username)
      hub = HejiaUserBbs.find :first, :select => "userbbsid, username, bbsid", :conditions => ["username = ?", username]
      if hub.nil?
        render :text => js("parent.p_username.innerHTML='用户名可以使用!'; parent.p_username.className='STYLE5'; ")
      else
        render :text => js("parent.p_username.innerHTML='用户名已经存在!'; parent.p_username.className='wrongtips'; ")
      end
    end
  end
  
  def check_reg_email()
    email = trim(params[:email].to_s)
    if pp(email)
      hub = HejiaUserBbs.find :first, :select => "userbbsid, username, bbsid", :conditions => ["userbbsemail = ?", email]
      if hub.nil?
        render :text => js("parent.p_userbbsemail.innerHTML='邮箱可以使用!'; parent.p_userbbsemail.className='STYLE5'; ")
      else
        render :text => js("parent.p_userbbsemail.innerHTML='邮箱已经存在!'; parent.p_userbbsemail.className='wrongtips'; ")
      end
    end
  end
  
  def check_email()
    email = trim(params[:email].to_s)
    if pp(email)
      hub = HejiaUserBbs.find :first, :select => "userbbsid, username, bbsid", :conditions => ["userbbsemail = ?", email]
      if hub.nil?
        render :text => js("parent.p_userbbsemail.innerHTML='Email地址可以使用!'; parent.p_userbbsemail.className='STYLE5'; ")
      else
        render :text => js("parent.p_userbbsemail.innerHTML='Email地址已经存在!'; parent.p_userbbsemail.className='wrongtips'; ")
      end
    end
  end
  
  def loginout
    forward = params[:forward].to_s.strip
    forward = 'http://www.51hejia.com' if forward.include?('member.51hejia.com') || !forward.include?('51hejia.com')

    ## bbs论坛退出（"1"退出失败，"0"退出成功）
    3.times do
      req = Net::HTTP::Post.new(URI.parse("http://bbs.51hejia.com/api/hjsso.php?action=synlogout").path)
      req.set_form_data({"username" => "#{current_user.USERNAME}", "authcode" => Digest::MD5.hexdigest("2011081551hejia" + current_user.USERNAME)})

      res = Net::HTTP.get_response(URI.parse("http://bbs.51hejia.com/api/hjsso.php?action=synlogout&#{req.body}"))
      break if res.body == "status=0"
    end
    logout_user!
    ## bbs论坛实际退出
    for cookie in cookies
      if cookie.first.include?("_auth")
        cookies.delete "#{cookie.first}", :domain => '.51hejia.com'
      end
    end
    render :text => alert("用户退出成功!") + js(top_load(forward))
  end

  ## bbs论坛退出接口(成功返回true，失败返回false)
  def bbs_loginout
    name = params[:s_username].to_s.strip
    authcode = params[:authcode].to_s.strip
    if authcode == Digest::MD5.hexdigest("2011081551hejia" + name)
      if HejiaUserBbs.find_by_USERNAME(name)
        logout_user!
        render :text => "status=0"
        return true
      else
        render :text => "status=1"
        return false
      end
    else
      render :text => "status=1"
      return false
    end
  end
  
  def login
    @forward = trim(params[:forward])
    @forward = "http://www.51hejia.com" if @forward.blank? || @forward == "http://"
    render :text => js(top_load(@forward)) if ilogin
  end
  
  def ilogin  #个人会员登录
    name = params[:s_username].to_s.strip
    password = params[:s_userpwd].to_s.strip
    return 'name and password cannot blank' if name.blank? || password.blank?
    name = iconv(name) unless RAILS_ENV == 'development'
    hub = HejiaUserBbs.authenticate(name, password)
    if hub.nil?
      render :text => alert_error("登录失败：用户名或密码错误!")
      return false
    elsif hub.freeze_date && hub.freeze_date > Time.now
      render :text => alert_error("登录失败：您的帐户已暂被冻结，如有疑问可直接联系客服人员！")
      return false
    else

      bbs_set_cookie(name, password)

      #登录验证成功
      days_from_now = params[:keeplogin].to_i * 30
      login_user!(hub, days_from_now == 0 ? nil : days_from_now.days.from_now)

      if hub.deco_id && hub.deco_id != 0
        # 为了兼容PHP的做法。
        cookies["deco_firm_id"] = {:value => "#{hub.deco_id}", :domain => ".51hejia.com"}
        cookies["ukey"] = {:value => Digest::MD5.hexdigest("#{session['user:user:id']}"+"#{hub.deco_id}"+"hejia2011"), :domain => ".51hejia.com"}
        @forward = "http://zxgs.51hejia.com"
      end

      ## 记录用户登录时间
      hub.update_attribute(:LOGINDATE , Time.now)
      return true
    end
  end

  ## bbs论坛登录接口(成功返回true，失败返回false)
  def bbs_login
    name = params[:s_username].to_s.strip
    password = params[:s_userpwd].to_s.strip
    authcode = params[:authcode].to_s.strip
    return false if name.blank? || password.blank?
    name = iconv(name) unless RAILS_ENV == 'development'
    hub = HejiaUserBbs.authenticate(name, password)
    if hub.nil?
      render :text => "status=1"
      return false
    elsif hub.freeze_date && hub.freeze_date > Time.now
      render :text => "status=1"
      return false
    else
      if authcode == Digest::MD5.hexdigest("2011081551hejia" + name + password)
        #登录验证成功
        login_user!(hub, nil)
        ## 记录用户登录时间
        hub.update_attribute(:LOGINDATE , Time.now)
        render :text => "status=0"
        return true
      else
        render :text => "status=1"
        return false
      end
    end
  end

  
  def show_login_gb2312
    render :layout => false
    #show_login
  end
  
  def show_login
    render :layout => false
    #    case get_userstatus
    #    when "ind"
    #      render :text => "document.write(\"<a href='http://member.51hejia.com/member/userinfo' target='_blank' id='dl'><img src='http://member.51hejia.com/images/myhejia.gif' alt='个人会员' width='64' height='20' border='0' align='absmiddle' /></a>			<a href='http://member.51hejia.com/member/loginout?forward=\" + top.location.href + \"' target='hideiframe_loginout'><img src='http://member.51hejia.com/images/loginout.gif' width='36' height='20' border='0' align='absmiddle' /></a>\");"
    #    when "vendor"
    #      render :text => "document.write(\"<a href='#' target='_self' id='dl'><img src='http://member.51hejia.com/images/myhejia.gif' alt='企业会员' width='64' height='20' border='0' align='absmiddle' /></a>			<a href='http://member.51hejia.com/member/loginout?forward=\" + top.location.href + \"' target='hideiframe_loginout'><img src='http://member.51hejia.com/images/loginout.gif' width='36' height='20' border='0' align='absmiddle' /></a>\");"
    #    else
    #      render :text => "document.write(\"<a href='#de' id='dl' onclick=\\\"Divopop('Login');return false;\\\"><img src='http://www.51hejia.com/images/Common/Login_New.gif' width='64' height='20' border='0' align='absmiddle' /></a>			<a href='http://member.51hejia.com/member/reg?forward=\" + top.location.href + \"' target='_blank'><img src='http://www.51hejia.com/images/Common/Reg_New.gif' width='36' height='20' border='0' align='absmiddle' /></a>\");"
    #    end
  end
  
  def shortcut_login
    user_id = get_user_id_by_cookie_name()
    if user_id > 0
      render :text => "document.write(\"<iframe name='hideiframe_login2' width='0' height='0' style='display: none;'></iframe>#{current_user.USERNAME}您好: <a href='http://member.51hejia.com/member/userinfo' target='_blank'>[我的资料]</a> <a href='http://member.51hejia.com/member/loginout?forward=\" + top.location.href + \"' target='hideiframe_login2'>[退出]</a>\");"
    else
      render :text => "document.write(\"<iframe name='hideiframe_login2' width='0' height='0' style='display: none;'></iframe><form action='http://member.51hejia.com/member/login' target='hideiframe_login2'>用户名: <input name='s_username' type='text' style='width:70px;height:17px;' />&nbsp;&nbsp;密码: <input name='s_userpwd' type='password' style='width:70px;height:17px;' /><input name='forward' type='hidden' value='\" + top.location.href + \"'>&nbsp;&nbsp;<select name='keeplogin'><option value='0'>不保持</option><option value='1'>1个月</option><option value='3' selected>3个月</option><option value='12'>一年</option></select>&nbsp;&nbsp;<input type='submit' value='登 录' />&nbsp;&nbsp;<a href='http://member.51hejia.com/member/reg' target='_blank' title='免费注册'>注册</a></form>\");"
    end
  end
  
  def activity_reg #注册活动信息
    housemodel = params[:housemodel] + " " if pp(params[:housemodel])
    housemodel += params[:housemodel1] + "室" if pp(params[:housemodel1])
    housemodel += params[:housemodel2] + "厅" if pp(params[:housemodel2])
    housemodel += params[:housemodel3] + "卫" if pp(params[:housemodel3])
    
    userfavortag=""
    userfavortag += params[:userfavortag1]+"," if pp(params[:userfavortag1])
    userfavortag += params[:userfavortag2]+"," if pp(params[:userfavortag2])
    userfavortag += params[:userfavortag3]+"," if pp(params[:userfavortag3])
    userfavortag += params[:userfavortag4]+"," if pp(params[:userfavortag4])
    userfavortag += params[:userfavortag5]+"," if pp(params[:userfavortag5])
    userfavortag += params[:userfavortag6]+"," if pp(params[:userfavortag6])
    userfavortag += params[:userfavortag7]+"," if pp(params[:userfavortag7])
    userfavortag += params[:userfavortag8]+"," if pp(params[:userfavortag8])
    userfavortag += params[:userfavortag9]+"," if pp(params[:userfavortag9])
    
    @hu = HejiaUserActivity.new
    @hu.ACTIVITYID = 1
    @hu.CREATETIME = Time.now
    @hu.NAME = iconv(trim(params[:name])) if pp(params[:name])
    @hu.SEX = iconv(trim(params[:sex])) if pp(params[:sex])
    @hu.MOBILE = trim(params[:mobile]) if pp(params[:mobile])
    @hu.HOUSEADDRESS = iconv(trim(params[:houseaddress])) if pp(params[:houseaddress])
    @hu.EMAIL = trim(params[:email]) if pp(params[:email])
    @hu.HOUSEAREA = trim(params[:housearea]) if pp(params[:housearea])
    @hu.HOUSEMODEL = iconv(housemodel) if pp(housemodel)
    @hu.USERFAVORTAG = userfavortag if pp(userfavortag)
    @hu.save
  end
  
  def uploadfile
    if params[:upload_save].nil?
      render :layout => false
    else
      @imgurl = get_file(params[:FindFile], "/uploads/headimg/")
      render :layout => false
    end
  end
  
  # 公司注册
  def reg_company
    session[:forward] = trim(params[:forward])
    render :layout => false
  end
  
  # 公司注册保存
  def reg_com_save
    return false if !pp(params[:username]) || !pp(params[:userbbsemail])
    begin
      hub = HejiaUserBbs.new
      hub.USERNAME = iconv(trim(params[:username]))
      hub.USERBBSEMAIL = trim(params[:userbbsemail])
      hub.BBSID = Time.now.strftime("%Y_%m_%d_%H_%M_%S")
      hub.USERTYPE = 1
      hub.USERBBSSEX = iconv(params[:gender])
      hub.AREA = trim(params[:area])
      hub.CITY = trim(params[:city])
      hub.USERSPASSWORD = HejiaUserBbs.md5(trim(params[:userpassword]))
      hub.CREATTIME = Time.now
      hub.LOGINDATE = Time.now
      
      ask_expert = params[:ask_expert].to_i rescue 0
      if ask_expert > 0
        #专家注册
        hub.HEADIMG = params[:headimg]
        hub.ask_expert = -ask_expert  #负数代表申请中
        hub.USERBBSNAME = iconv(params[:userbbsname])
        hub.USERBBSROLE = iconv(params[:userbbsrole])
        hub.REMARK = params[:remark]
        hub.USERBBSREADME = iconv(params[:userbbsreadme]) if pp(params[:userbbsreadme])
        hub.USERBBSTEL = params[:userbbstel]
        hub.QQ = params[:qq] if pp(params[:qq])
        hub.MSN = params[:msn] if pp(params[:msn])
        hub.save
      else
        #普通会员注册
        hub.HEADIMG = "http://member.51hejia.com/images/headimg/default.gif"
        repairEnjoy = ""
        repairEnjoy += params[:repairEnjoy1]+"," if pp(params[:repairEnjoy1])
        repairEnjoy += params[:repairEnjoy2]+"," if pp(params[:repairEnjoy2])
        repairEnjoy += params[:repairEnjoy3]+"," if pp(params[:repairEnjoy3])
        hub.ask_expert = 0
        hub.USERBBSTEL = trim(params[:userBbsTel]) if pp(params[:userBbsTel])
        hub.REPAIRENJOY = iconv(trim(repairEnjoy)) if pp(repairEnjoy)
        hub.REPAIRTYPE = iconv(trim(params[:repairType])) if pp(params[:repairType])
        hub.REPAIRTIME = iconv(trim(params[:repairTime])) if pp(params[:repairTime])
        hub.save
        activity_reg if pp(params[:name])|| pp(params[:mobile]) #注册活动信息
      end
      
      decofirm = DecoFirm.new
      decofirm.name_zh = trim(params[:name_zh])
      decofirm.name_abbr = trim(params[:name_abbr])
      decofirm.city = trim(params[:area])
      decofirm.district = trim(params[:city])
      decofirm.detail = trim(params[:detail])
      decofirm.address = trim(params[:address])
      decofirm.linkman = trim(params[:linkman])
      decofirm.telephone = trim(params[:telephone])
      decofirm.fax = trim(params[:fax])
      decofirm.traffic = trim(params[:traffic])
      decofirm.state = '-100'
      decofirm.source_type = 2
      decofirm.created_at = Time.now
      decofirm.updated_at = Time.now
      decofirm.save

      login_user! hub

      cookies["editer_id"] = {:value => hub.USERBBSID.to_s, :domain=>".51hejia.com"}
      hub.update_attribute(:deco_id , decofirm.id)
      if pp(params[:forward])
        forward = params[:forward]
      else
        forward = session[:forward].to_s
        session[:forward] = nilss
      end
      #    forward = "http://www.51hejia.com" if forward == "" || forward == "http://"
      forwordnew = "http://z.51hejia.com/dianping/newdp/#{decofirm.id}"
      render :text => alert("用户注册成功!") + js("top.location.href='#{forwordnew}';")
    rescue Exception => e
      render :text => alert("注册失败：用户名或邮箱已经存在。") #alert(get_error(iconv(e)))
    end
  end
  
  #公司信息录入
  def company
    id = params[:id]
    @decofirm = DecoFirm.find(id)
    render :layout => false
  end
  
  #公司信息录入保存
  def company_save
    id = params[:id]
    @decofirm = DecoFirm.find(id)
  end
  
  def check_name_zh
    username = trim(params[:username].to_s)
    if pp(username)
      hub = DecoFirm.find :first,:conditions => ["name_zh = ?", username]
      if hub.nil?
        render :text => js("parent.p_name_zh.innerHTML='公司名可以使用!'; parent.p_name_zh.className='STYLE5'; ")
      else
        render :text => js("parent.p_name_zh.innerHTML='公司名已经存在!'; parent.p_name_zh.className='wrongtips'; ")
      end
    end
  end
  
  def usercollections
    @type = params[:type] || '0'
    @user_id = current_user.id
    @username = current_user.USERNAME
    
    @pagesize = 12 #每页记录数
    @listsize = 10 #同时显示的页码数
    cd = "true"
    cd += " and obj_type = #{@type} and user_id = #{@user_id}"
    
    if params[:page].nil?
      @curpage = 1
    else
      @curpage = params[:page].to_i
    end
    if params[:recordcount].nil?
      @recordcount = UserCollection.count("id", :conditions => cd)
    else
      @recordcount = params[:recordcount].to_i
    end
    @pagecount = (1.0 * @recordcount / @pagesize).ceil
    
    @collections = UserCollection.find :all,
      :select => "id, obj_id, obj_type, obj_name, url, photo_url, created_at",
      :conditions => cd,
      :order => 'id desc',
      :offset => @pagesize * (@curpage - 1),
      :limit => @pagesize
    
  end
  
  def collection_del
    id = "0,#{params[:id]}"
    UserCollection.delete_all("id in (#{id})")
    redirect_to :action => "usercollections",:type => params[:type]
  end
  
  #点评
  def dianping_list
    userid = current_user.id
    puts "==========="
    puts userid
    orderby = "id desc"
    conditions = []
    conditions << "formid = '#{$formid}' and status != '-1'"
    conditions << "c2 = #{userid}"
    @reviews = DecoReview.paginate :page => params[:page], :per_page => 20,
      :conditions => conditions.join(" and "),
      :order => orderby
  end
  
  
  
  def dianping_del
    ids = params[:ids]
    DecoReply.update_all("status = '-1'", "id in ( #{ids} )")
    redirect_to :action =>'dianping_list'
  end
  
  # 回应
  def reply_list
    userid = current_user.id
    puts userid
    conditions = []
    conditions << "formid = #{$replyid}"
    conditions << "c2 = #{userid}"
    @replys = DecoReply.paginate :page => params[:page], :per_page => 20,:conditions => conditions.join(' and '),:order => "id desc"
  end
  def reply_del
    ids = params[:ids]
    DecoReply.delete_all("id in (#{ids})")
    redirect_to :action =>'reply_list'
  end
  
  # 得到session里面的图片地址
  def getimagepath
    path = session[:backitem]
    return path
  end
  
  def clearsession
    session[:backitem]=nil
  end
  
 
  
  def companylist
    @cities = get_cities
    @name = params[:name]
    @city = params[:diary_city]
    decofirm = DecoFirm.get_deco_firms(@name,@city)
    @decofirms = decofirm.paginate :page => params[:page], :per_page => 12
    render :layout => 'none.rhtml'
  end
  
  # 执行查询某省市下的区县信息
  def select_city_area
    @area = get_areas2(params[:cityid])
    render :partial => "select_city_area"
  end
  
  #根据省市编号取得各省市下的地区域Hash
  def get_areas2(cityid)
    if cityid.to_i == 0
      areas = Hash.new
      return areas
    end
    key = "zhaozhuangxius_area_#{cityid}_#{Time.now.strftime('%Y%m%d')}"
    DecoReply
    if CACHE.get(key).nil?
      as = DecoReply.find(:all, :select => "tagid,tagname", :from => "HEJIA_TAG", :conditions => "tagfatherid = #{cityid}")
      areas = Hash.new
      as.each do |a|
        areas[a.tagid.to_i] = a.tagname
      end
      CACHE.set(key,areas)
    else
      areas = CACHE.get(key)
    end
    return areas
  end
  
  #取得所有省的hash
  def get_cities
    {11910 => '上海', 12117 => '苏州', 12301 => '宁波', 12306 => '杭州', 12118 => '无锡'}
  end

  def development
    redirect_to "http://seven.51hejia.com:#{request.env["SERVER_PORT"]}"
  end



  ## bbs论坛登录接口动作
  def bbs_set_cookie(name, password)
    re = Net::HTTP::Get.new(URI.parse("http://bbs.51hejia.com/api/hjsso.php?action=synlogin").path)
    re.set_form_data({"username" => name, "password" => password, "authcode" => Digest::MD5.hexdigest("2011081551hejia" + name + password)})
    uri = URI.parse("http://bbs.51hejia.com/api/hjsso.php?action=synlogin&#{re.body}")
    logger.info("http://bbs.51hejia.com/api/hjsso.php?action=synlogin&#{re.body}")
    req = Net::HTTP::Get.new(uri.request_uri)
    req.initialize_http_header({"User-Agent" => request.env["HTTP_USER_AGENT"]})
    @http_response = Net::HTTP.new(uri.host, uri.port).start {|http| http.request(req) }
    logger.info(request.env["HTTP_USER_AGENT"])
    logger.info(@http_response.get_fields('Set-Cookie'))
    unless @http_response.get_fields('Set-Cookie').blank?
      for cookie in @http_response.get_fields('Set-Cookie')
        cookie_str = cookie.split(";")[0]
        cname = trim(cookie_str.split("=")[0]).to_s
        if cname.include?("_auth")
          cookies["#{cname}"] = {:value => URI.decode(cookie_str.split("=")[1].to_s), :domain => '51hejia.com', :expires => 1.days.from_now}
        end
      end
    end
  end
end
