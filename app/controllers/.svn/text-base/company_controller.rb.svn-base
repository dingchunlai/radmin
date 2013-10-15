# -*- coding: utf-8 -*-
class CompanyController < ApplicationController
  #公司列表
  def index
    @companyname = params[:companyname]
    conditions = []
    conditions << "STATUS <> '-100' "
    conditions << "TYPE = '12362' "
    conditions << "CN_NAME like '%#{@companyname}%' " if @companyname
    
    @companylist = Company.paginate :page => params[:page], :per_page => 20,
      :conditions => conditions.join(" and "),
      :order => ' ID DESC '
  end
  
  #跳转前台修改内容，设置cookie
  def linktofront
    if staff_logged_in?
      staff = current_staff
      if !staff.editer_id.nil?
        editer_id = staff.editer_id
      else
        editer_id = staff.id
      end
      cookies["editer_id"] = {:value => editer_id.to_s, :domain=>".51hejia.com"}
    end

    # 为了兼容PHP的做法。
    cookies["ind_id"] = {:value => "7134345", :domain => ".51hejia.com"}
    cookies["deco_firm_id"] = {:value => params[:companyid], :domain => ".51hejia.com"}
    cookies["ukey"] = {:value => Digest::MD5.hexdigest("7134345"+params[:companyid]+"hejia2011"), :domain => ".51hejia.com"}

    # 这是后台(radmin)跳到前台(member)去编辑装修公司信息。
    # 就因为逻辑写得实在太恶心，所以导致了要恶心的假装一个前台用户登录了。
    # 这貌似是张楠的前台帐号（根据以前代码）
    login_user! HejiaUserBbs.find_by_USERBBSID(7134345)

    cookies["back"] = {:value => "back", :domain=>".51hejia.com"}
    session['deco_firm_id'] = params[:companyid]
    redirect_to 'http://zxgs.51hejia.com'
=begin
    if params[:companyid] == "7"
      redirect_to 'http://member.51hejia.com/deco/case_list'
    else
      redirect_to "http://member.51hejia.com/decos/edit"
    end
=end
  end
  
  #新增装潢公司
  def new
    
    if request.post?
      cs = Company.find(:all,:conditions => ["CN_NAME = '#{params[:companyname]}'"])
      if cs.size >0
        @message = 1
      else
        company = Company.new
        company.CN_NAME = params[:companyname]
        company.STATUS = '000'
        company.CREATEDATE = Time.now
        company.TYPE = '12362'
        company.COMPANYCITY = 11910
        company.STARCLASS = params[:starclass]
        company.SPECIAL = params[:special]
        company.save
        redirect_to :action => 'index'
      end
    end
  end
  
  #显示公司
  def show
    @company = Company.find(params[:id])
  end
  
  #修改公司
  def edit
    company = Company.find(params[:id])
    company.STARCLASS = params[:starclass]
    company.SPECIAL = params[:special]
    company.CN_NAME = params[:companyname] if params[:companyname]
    company.save
    redirect_to :action => 'show',:id => params[:id]
  end
  
  #逻辑删除
  def delete
    company = Company.find(params[:id])
    company.STATUS = '-100'
    company.save
    redirect_to :action => 'index'
  end
  
  
  
  # 修改密码 完善deco表信息 是否修改邮件后要发邮件呢？
  def chpass
    
    @user_id = params[:user_id]
    
    if request.post?
      if (params[:PASSWORD] == params[:CONFIRM_PASSWORD]) && !params[:PASSWORD].blank?
        HejiaUserBbs.update(@user_id,:USERSPASSWORD => Digest::MD5.hexdigest(params[:PASSWORD]))
        flash[:notice] = "密码修改成功"
        redirect_to :action => :index
        return
      else
        @error = "输入的密码不匹配,或者为空"
      end
    end
    
  end
  
  def confirm
    
    unless params[:id].blank?
      DecoInfo.find_by_sql(["UPDATE HEJIA_COMPANY SET HEJIA_COMPANY.`confirm` = 1 where ID=? ", params[:id]]) rescue ""
      confirm = %Q|<a href="#" onclick="new Ajax.Updater('confirm_#{params[:id]}', '/company/deny/#{params[:id]}', {asynchronous:true, evalScripts:true, onComplete:function(request){new Effect.Highlight(&quot;confirm_#{params[:id]}&quot;,{});}}); return false;" style="color: red">鍙栨秷璁よ瘉</a>|
      
      render :text => confirm
    else
      render :nothing => true
      
    end
  end
  
  def deny
    unless params[:id].blank?
      DecoInfo.find_by_sql(["UPDATE HEJIA_COMPANY SET HEJIA_COMPANY.`confirm` = 0 where ID=? ", params[:id]]) rescue ""
      deny = %Q|<a href="#" onclick="new Ajax.Updater('confirm_#{params[:id]}', '/company/confirm/#{params[:id]}', {asynchronous:true, evalScripts:true, onComplete:function(request){new Effect.Highlight(&quot;confirm_#{params[:id]}&quot;,{});}}); return false;" style="color: black">杩涜璁よ瘉</a>|
      render :text => deny
    else
      render :nothing => true
    end
  end
  def findform
    @companyid = params[:id]
    @message = nil
    @message = params[:message]
    @formid = COMPANY_FORMID.to_i
  end
  
  def form_save
    @username = params[:username]
    @c1 = params[:c1]
    @c2 = nil
    @c3 = params[:c3]
    @c4 = params[:c4]
    @c5 = params[:c5]
    @c6 = params[:c6]
    @c7 = params[:c7]
    @formid = COMPANY_FORMID.to_i
    @f_id = params[:f_id]
    @c_id = params[:c_id]
    fd = Fdata.new
    fd.formid = COMPANY_FORMID.to_i
    fd.userip = request.remote_ip
    fd.cdate = getnow
    fd.udate = getnow
    @message = nil
    hejiauserbbsmodel = HejiaUserBbs.find(:first,:conditions => ["USERNAME = '#{params[:username]}'"])
    if !hejiauserbbsmodel.nil?
      fd.c1 = params[:c1]
      fd.c2 = hejiauserbbsmodel.USERBBSID
      @c2 = hejiauserbbsmodel.USERBBSID
      fd.c3 = params[:c3]
      fd.c4 = params[:c4]
      fd.c5 = params[:c5]
      fd.c6 = params[:c6]
      fd.c7 = params[:c7]
      fd.c8 = params[:c3].to_i+params[:c4].to_i+params[:c5].to_i+params[:c6].to_i
      fd.save
      
      Countresult.docount(@formid,'1',@c1,'1')  #统计用
      
      @message = "回复成功"
      redirect_to :action => 'findform' ,:id=>params[:c1],:message=>@message
    else
      @message = "用户不存在请确认"
    end
  end
  
  #公司分数
  def companyscore
    @names = Countresult.getitemnames(params[:companyid],'1')
    @scores = Countresult.getitemvalues(params[:companyid],'1')
  end
  
  #公司评论查看
  def companyping 
  
    @c7 = params[:c7]
    @status = params[:status].to_i
    @check = '0'
    @check = params[:check]
    #    puts "=================="+@check
    formid = COMPANY_FORMID.to_i
    condition = "formid='#{formid}'"
    if !@c7.nil?
      condition += " and c7 like'%"+@c7+"%'"
    end
    if !@status.nil?
      condition += " and status = #{@status}" if @status
    end
    @list = Fdata.paginate :page => params[:page], :per_page => 20,
      :conditions => condition,
      :order => ' id DESC '
  end
  
  def delete_all
    #   FilterWord.delete_all "id in (#{params[:ids]})" unless params[:ids].nil?
    Fdata.delete_all("id in (#{params[:ids]})") unless params[:ids].nil?
    @check = 2
    redirect_to :action => 'companyping',:check=>@check
  end
  
  def shenhe
    Fdata.update_all("status = '1'", "id in (#{params[:ids]})") unless params[:ids].nil?
    @check = 1
    redirect_to :action => 'companyping',:check=>@check
  end
  #组合字符串
  #  def getarryvalue(arr)
  #    arr.each do |id|
  #      ids = @ids + id+' '
  #    end
  #    ids = @ids.strip
  #    ids = @ids.gsub(' ', ',')
  #
  #    return ids
  #  end
  
  #上传文件相关
  #  def getFileName(file)
  #    Time.now.strftime("%Y%m%d").to_s+Time.now.to_i.to_s+file.original_filename
  #  end
  #
  #  def uploadFile(file,fname)
  #    if fname && fname != ''
  #      filename=fname
  #    else
  #      filename=getFileName(file)
  #    end
  #
  #    File.delete("#{RAILS_ROOT}/public/files/companylogo/#{@filename}") if File.exist?("#{RAILS_ROOT}/public/files/companylogo/#{@filename}")
  #    File.open("#{RAILS_ROOT}/public/files/companylogo/#{@filename}", "wb") do |f|
  #      f.write(file.read)
  #    end
  #
  #    return filename
  #
  #  end
end
