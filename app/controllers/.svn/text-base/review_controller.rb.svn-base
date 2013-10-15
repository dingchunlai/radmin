class ReviewController < ApplicationController
  #后台评论搜索
  
  $formid=PINGLUN_ID
  $replyid=88
  
  #人工干预口碑
  def update_this_adjusted_praise
    adjusted_praise = params[:company][:adjusted_praise].to_f
    firm = DecoFirm.find params[:company][:company]
    DecoFirm.update_all([
        'adjusted_praise = ?, ' +
          'praise = ?',
        adjusted_praise, firm.nonadjusted_praise + adjusted_praise
      ], :id => firm.id)

    redirect_to request.env["HTTP_REFERER"]
  end
  #人工服务口碑
  def update_service_adjusted_praise
    adjusted_service_praise = params[:company][:adjusted_service_praise].to_f
    firm = DecoFirm.find params[:company][:company]
    DecoFirm.update_all([
        'adjusted_service_praise = ?, ' +
          'service_praise = ?',
        adjusted_service_praise, firm.nonadjusted_service_praise + adjusted_service_praise
      ], :id => firm.id)

    redirect_to request.env["HTTP_REFERER"]
  end

  #人工设计口碑
  def update_design_adjusted_praise
    adjusted_design_praise = params[:company][:adjusted_design_praise].to_f
    firm = DecoFirm.find params[:company][:company]
    DecoFirm.update_all([
        'adjusted_design_praise = ?, ' +
          'design_praise = ?',
        adjusted_design_praise, firm.nonadjusted_design_praise + adjusted_design_praise
      ], :id => firm.id)

    redirect_to request.env["HTTP_REFERER"]
  end

  #人工施工口碑
  def update_construction_adjusted_praise
    adjusted_construction_praise = params[:company][:adjusted_construction_praise].to_f
    firm = DecoFirm.find params[:company][:company]
    DecoFirm.update_all([
        'adjusted_construction_praise = ?, ' +
          'construction_praise = ?',
        adjusted_construction_praise, firm.nonadjusted_construction_praise + adjusted_construction_praise
      ], :id => firm.id)

    redirect_to request.env["HTTP_REFERER"]
  end
    
  #手动修改浏览量（pv）
  def update_adjusted_pv
    diary = DecorationDiary.find params[:diary]
    diary.pv = params[:pv]
    redirect_to request.env["HTTP_REFERER"]
  end

  #手动修改投票数量（votes_current_month）
  def update_adjusted_votes
    diary = DecorationDiary.find params[:diary]
    REDIS_DB.set "diary/show/#{diary.id}/toupiao", REDIS_DB.get("diary/show/#{diary.id}/toupiao").to_i + params[:diary][:adjust_vote].to_i
    diary.class.connection.execute "UPDATE #{diary.class.table_name} SET adjust_vote = #{params[:adjust_vote].to_i}, votes_current_month = #{diary.votes_current_month + params[:adjust_vote].to_i}, votes_sum = #{diary.votes_sum + params[:adjust_vote].to_i} where id=#{diary.id}"
    redirect_to :action => 'note_list',:title => params[:title],:companyname => params[:companyname],:status => params[:status],:page => params[:page],:city => params[:city],:price => params[:price],:isgood => params[:isgood],:begintime => params[:begintime],:endtime => params[:endtime],:vote => params[:vote]
  end

  #修改类型
  def updatetype
    ids = getids()
    newtype = params[:newtype]
    DecoReview.update_all("c15 = '#{params[:newtype]}'", "id in ( #{ids} )")
    
    redirect_to :action => "index",
      :companyname => params[:companyname],
      :type => params[:type],
      :status => params[:status]
  end
  
  #修改类型
  def updatetype2
    ids = getids()
    newtype = params[:newtype]
    DecoReview.update_all("c15 = '#{params[:newtype]}'", "id in ( #{ids} )")
    
    redirect_to :action => "back_commont_list",
      :begintime => params[:begintime],
      :endtime => params[:endtime],
      :price => params[:price],
      :model => params[:model],
      :style => params[:style],
      :order => params[:order],
      :type => params[:type],
      :status => params[:status],
      :author => params[:author],
      :rijimain => params[:rijimain]
  end  
  
  #删除,确认功能,公司表里相应评论数加减
  def updatestate
    ids = getids
    newstate = params[:newstate]
    count = 5+rand(20)
    rcount = count.to_i
    DecoReview.update_all("status = '#{newstate}'", "id in ( #{ids} )")
    if newstate=="1"
      DecoReview.update_all("c32 = '#{rcount}'", "id in ( #{ids} )")
      list = DecoReview.find(:all,:conditions =>"id in ( #{ids} )")
      if list.size>0
        list.each do |f|
          dianping_key = "test_zhaozhuangxiu_key_d_#{f.id}"
          record_visit_count(dianping_key)
          key = "test_analytic_zhaozhuangxiu_company_about_key_d_#{f.c1}"
          record_visit_count(key)
          update_firms_time(f.cdate,f.c1)
        end
      end
    end
    
    redirect_to :action => "index",
      :companyname => params[:companyname],
      :type => params[:type],
      :status => params[:status],
      :page => params[:page]
  end
  
  #删除,确认功能,公司表里相应评论数加减
  def updatestate2
    ids = getids
    newstate = params[:newstate]
    count = 5+rand(20)
    rcount = count.to_i
    DecoReview.update_all("status = '#{newstate}'", "id in ( #{ids} )")
    if newstate=="1"
      DecoReview.update_all("c32 = '#{rcount}'", "id in ( #{ids} )")
      list = DecoReview.find(:all,:conditions =>"id in ( #{ids} )")
      if list.size>0
        list.each do |f|
          dianping_key = "test_zhaozhuangxiu_key_d_#{f.id}"
          record_visit_count(dianping_key)
          key = "test_analytic_zhaozhuangxiu_company_about_key_d_#{f.c1}"
          record_visit_count(key)
          update_firms_time(f.cdate,f.c1)
        end
      end
    end
    redirect_to :action => "back_commont_list",
      :begintime => params[:begintime],
      :endtime => params[:endtime],
      :price => params[:price],
      :model => params[:model],
      :style => params[:style],
      :order => params[:order],
      :type => params[:type],
      :status => params[:status],
      :author => params[:author],
      :rijimain => params[:rijimain]
  end  
  
  #认证
  def renzheng
    ids = getids
    DecoReview.update_all("c9 = '1'", "id in ( #{ids} )")
    
    redirect_to :action => "index",
      :companyname => params[:companyname],
      :type => params[:type],
      :status => params[:status]
  end
  
  #回复列表
  def replyindex
    @replycontent = params[:replycontent]
    conditions = []
    conditions << "formid = #{$replyid}"
    conditions << "c30 like '%#{@replycontent}%'" if @replycontent && @replycontent != ''
    @replys = DecoReply.paginate :page => params[:page], :per_page => 20,:conditions => conditions.join(' and '),:order => "id desc"
  end
  
  #删除回复 
  def replydelete
    if params[:review] && params[:review][:selected_ids]
      params[:review][:selected_ids].each do |id|
        DecoReply.delete("#{id}")
      end
    end
    redirect_to :action => "replyindex",:replycontent => params[:replycontent]
  end
  
  #后台回复
  def back_reply
    @review_id = params[:review_id]
    review = DecoReview.find(@review_id)
    if review.city_id == 11910 || review.city_id == 11905 || review.city_id == 31959
      @majias = get_bbs_users_by_conditions(review.city_id, current_staff.id)
    else
      @majias = get_bbs_users_by_conditions(@review.district, current_staff.id)
    end
    if request.post?
      reply = DecoReply.new
      reply.formid = $replyid
      reply.user_id = '0'
      reply.replytype = '1'
      reply.username = params[:username]
      reply.content = params[:content]
      reply.userurl = "http://member.51hejia.com/images/headimg/#{rand(100).to_s}.gif"
      reply.cdate = Time.now
      reply.udate = Time.now
      reply.review_id = @review_id
      reply.user_id = params[:majia] if params[:majia].to_i != 0
      reply.userip = request.remote_ip
      reply.save!
      @message = "1"
      redirect_to :action => 'back_reply_edit',:replyid => reply.id,:message => '1'
    end
  end
  
  #回复修改
  def back_reply_edit
    @replyid = params[:replyid]
    @reply = DecoReply.find(@replyid)
    @message = params[:message] if params[:message]
    if request.post?
      @reply.content = params[:content]
      @reply.save
      @message = "2"
    end
  end
  
  #修改单个评论,需要实时统计用
  def updatesingletype(review,newstate)
    company = DecoFirm.find(review.company_id)
    #保存公司评论数
    company.comments_count = DecoReview.countallreview($formid,review.company_id)
    company.save
    #保存评论状态
    review.status = newstate
    review.save
  end
  
  #获得选择的评论id，以','分开
  def getids()
    ids = ''
    if params[:review] && params[:review][:selected_ids]
      params[:review][:selected_ids].each do |id|
        ids = ids + id+' '
      end
      ids = ids.strip
      ids = ids.gsub(' ', ',')
    end
    return ids
  end
  
  def update_review_city
    DecoReview.update_review_city
    render :text => 'aaa'
  end
  
  #前台点评
  def new
    @companyid = params[:id]
    @company = DecoFirm.find(@companyid)
    
    if request.post?
      review = DecoReview.new
      review.company_id = @companyid
      review.user_id = current_user.id.to_s
      review.content = params[:content]
      review.area = params[:area]
      review.address = params[:address]
      review.phone = params[:phone]
      review.review_type = '1'
      review.flower_num = '0'
      review.response_num = '0'
      review.report_num = '0'
      review.formid = PINGLUN_ID
      review.userip = request.remote_ip
      review.cdate = Time.now
      review.udate = Time.now
      review.price = params[:price]
      review.style = params[:style]
      review.method = params[:method]
      if user_logged_in?
        if current_user.USERBBSNAME
          review.username = current_user.USERBBSNAME 
        else
          review.username = current_user.USERNAME 
        end
        review.c18 = review.username  #后台查看
        
        review.userurl = "http://member.51hejia.com/images/headimg/#{rand(100).to_s}.gif" 
        review.c9 = '1' if user.ischeck == 1
      end
      
      review.save
      @message = "1"
    end
    render :layout => false
  end
  #得到session里面的图片地址
  def getimagepath
    path = session[:backitem]
    return path
  end
  
  def clearsession
    session[:backitem]=nil
  end
  
  #基础数据维护
  def base_data_index
    @keyname = params[:keyname]
    conditions = []
    conditions << "status = 1"
    conditions << "name like '%#{@keyname}%' " if @keyname && @keyname != ''
    @datas = JfBase.paginate :page => params[:page], :per_page => 20,
      :conditions => conditions.join(' and '), :order =>"keyword desc , name"
    
  end
  
  #增加基础数据
  def base_data_add
    @kword = JfBase.get_keyword
    if request.post?
      if staff_logged_in?
        c = check_name_edit(params[:name])
        if c==0
          data = JfBase.new
          data.name = params[:name]
          data.keyword = params[:keyword]
          data.keytype = params[:keytype]
          data.start_num = params[:start_num]
          data.end_num = params[:end_num]
          data.value = params[:value]
          data.create_at = Time.now
          data.update_at = Time.now
          data.value2 = params[:value2]
          data.value3 = params[:value3]
          data.status = 1
          data.save!
          save_jf_link(current_staff.id, current_staff.rname, data.id, data.name, '1')
          redirect_to :action => 'base_data_index',:id => data.id,:message => '1'
          JfBase.kill_keyword_cache
        else
          redirect_to :action => 'base_data_add',:message => '3'
        end
      else
        redirect_to :controller =>'user',:action => 'hlogin'
      end
    end
  end
  
  #修改基础数据
  def base_data_edit
    @message = params[:message]
    @data = JfBase.find(params[:id])
    if request.post?
      if staff_logged_in?
        c = 0
        if @data.name==params[:name]
        else
          c = check_name_edit(params[:name])
        end
        if c==0
          @data.name = params[:name]
          @data.keyword = params[:keyword]
          @data.start_num = params[:start_num]
          @data.end_num = params[:end_num]
          @data.value = params[:value]
          @data.update_at = Time.now
          @data.value2 = params[:value2]
          @data.value3 = params[:value3]
          @data.save!
          @message = '2'  
          save_jf_link(current_staff.id, current_staff.rname, @data.id, @data.name, '2')
        else
          redirect_to :action => 'base_data_edit',:id => params[:id],:message => '3'
        end
      else
        redirect_to :controller =>'user',:action => 'hlogin'
      end
    end
  end
  
  #删除基础数据
  def base_data_delete
    data = JfBase.find(params[:delid])
    data.status = 0
    data.save!
    
    redirect_to :action => 'base_data_index',:page => params[:page],:keyname => params[:keyname]
  end
  
  #编辑修改某评论分数
  def commont_editor_score
    return false unless pvalidate("评论打分","管理员","页面制作")
    JfBase
    @important = get_important_score_item
    @real = get_real_score_item
    @editor = get_editor_score_item
    
    @commont_id = params[:commont_id]
    @score = JfCommontResultScore.find(:first,:conditions => "commont_id = '#{@commont_id}'")
    @score = JfCommontResultScore.new if !@score || !@score.id 
    
    if request.post?
      if @score && @score.id
      else
        @score.commont_id = @commont_id
      end
      @score.important_score = params[:important_score]
      @score.real_score = params[:real_score]
      @score.editor_score = params[:editor_score]
      @score.update_at = Time.now
      @score.save!
      @message = '1'
    end
  end
  def check_name()
    username = trim(params[:username].to_s)
    if pp(username)
      hub = JfBase.find :first, :select => "id,name", :conditions => ["name = ?", username]
      if hub.nil?
        render :text => js("parent.namecheck.innerHTML='用户名可以使用!';")
      else
        render :text => js("parent.namecheck.innerHTML='用户名已经存在!';")
      end
    end
  end
  
  def check_name_edit(name)
    result = 0
    hub = JfBase.find :first, :select => "id,name", :conditions => ["name = ?", name]
    if hub.nil?
      result = 0
    else
      result = 1
    end
    return result
  end
  
  def save_jf_link(user_id,user_name,jf_data_id,jf_data_name,status)
    jfl =JfDataLink.new
    jfl.user_id=user_id
    jfl.user_name = user_name
    jfl.jf_data_id = jf_data_id
    jfl.jf_data_name = jf_data_name
    jfl.create_at = Time.now
    jfl.update_at = Time.now
    jfl.status = status#0删除，1新建时的操作，2修改时的操作
    jfl.save
  end
  
  #后台评论列表
  def back_commont_list
    @cname = params[:cname]
    @title = params[:title]
    @city = params[:city]
    @author = params[:author]
    @begintime = params[:begintime]
    @endtime = params[:endtime]
    @price = params[:price]
    @model = params[:model]
    @style = params[:style]
    @order = params[:order]
    @type = params[:type]
    @status = params[:status]
    @author = params[:author]
    @rijimain = params[:rijimain]
    
    DecoFirm
    
    conditions = []
    conditions << "formid=#{PINGLUN_ID} and status = '1'"
    conditions << "c8 like '%#{@title}%'" if @title && @title != ''
    conditions << "exists (select 1 from deco_firms where name_zh like '%#{@cname}%' and deco_firms.id = c1)" if @cname && @cname != ''
    if @city.to_i == 11910 || @city.to_i == 11905 || @city.to_i == 31959
      conditions << "c26 = '#{@city.to_i}'"
    elsif @city.to_i > 0
      conditions << "c27 = '#{@city}'"
    end
    conditions << "cdate >= '#{@begintime}'" if @begintime && @begintime != ''
    conditions << "cdate <= '#{@endtime}'" if @endtime && @endtime != ''
    conditions << "c23 = '#{@price}'" if @price.to_i > 0
    conditions << "c21 = '#{@model}'" if @model.to_i > 0
    conditions << "c22 = '#{@style}'" if @style.to_i > 0
    conditions << "c15 = '#{@type}'" if @type && @type != ''
    conditions << "status = '#{@status}'" if @status && @status != ''
    conditions << "c18 like '%#{@author}%'" if @author && @author != ''
    conditions << "c25 = 0" if @rijimain == '1'       
    
    orderby = 'cdate desc'
    orderby = 'udate desc' if @order.to_i == 2
    orderby = 'CONV(c11,10,10) desc' if @order.to_i == 3
    @commonts = []
    @dv = DecoReview.paginate :page => params[:page], :per_page => 50, :conditions => conditions.join(' and '),:order => orderby
    @dv.each do |d|
      temp = []
      temp << JfCommontResultScore.find(:first,:conditions => "commont_id = '#{d.id}'")
      temp << d
      @commonts << temp
    end
    
  end
  
  #后台公司
  def back_company_list
    @cid = params[:cid]
    @cname = params[:cname]
    @city = params[:city]
    @price = params[:price]
    @style = params[:style]
    @model = params[:model]
    @order = params[:order]
    @district = params[:district]
    @is_cooperation = params[:is_cooperation]
    @areas = get_areas2(@city)
    
    #conditions = ["state <> '-100'"]

    @shangjia = params[:shangjia]
    conditions = []
    if @shangjia && @shangjia!='' && @shangjia.to_s=='1'
      conditions << "state is not null "
    elsif @shangjia && @shangjia!='' && @shangjia.to_s=='2'
      conditions << "state <> '-99' and state <> '-100'"
    elsif @shangjia && @shangjia!='' && @shangjia.to_s=='3'
      conditions << "state = '-99'"
    elsif @shangjia && @shangjia!='' && @shangjia.to_s=='4'
      conditions << "state = '-100'"
    else
      conditions << "state <> '-100'"
    end

    conditions << "name_zh like '%#{@cname}%'" if @cname && @cname != ''
    conditions << "id = #{@cid}" if @cid
    if @city.to_i == 11910 || @city.to_i == 11905 || @city.to_i == 31959
      conditions << "city = '#{@city.to_i}'"
      conditions << "district = '#{@district}'" if @district.to_i >0
    elsif @city.to_i > 0
      conditions << "district = '#{@city}'"
      conditions << "area = '#{@district}'" if @district.to_i >0
    end 
    conditions << "price = #{@price}" if @price.to_i > 0
    conditions << "style = #{@style}" if @style.to_i > 0
    conditions << "model = #{@model}" if @model.to_i > 0

    conditions << " is_cooperation = 1 " if @is_cooperation.to_i == 1
    conditions << " (is_cooperation =0 or is_cooperation is null) " if @is_cooperation.to_i == 2
    conditions << " is_cooperation = -1 " if @is_cooperation.to_i == 3
    orderby = 'praise desc'
    orderby = 'service_praise desc' if @order.to_i == 1
    orderby = 'design_praise desc' if @order.to_i == 2
    orderby = 'construction_praise desc' if @order.to_i == 3
    
    @companys = DecoFirm.paginate :page => params[:page], :per_page => 50, :conditions => conditions.join(' and '), :order => orderby
    
  end
  
  def back_company_delete
    firm = DecoFirm.find(params[:company_id])
    firm.state = '-100'
    firm.save!
    redirect_to :action => "back_company_list", :cname =>params[:cname],:city => params[:city],:price => params[:price],:style => params[:style],:model => params[:model],:order => params[:order],:district =>params[:district]
  end
  
  def check_start_num
    name = params[:name]
    x = params[:x]
    stn = JfBase.check_start_num(name,x)
    if stn.size>0 
      render :text => js("parent.startcheck.innerHTML='#{x}不可以使用';")
    else
      render :text => js("parent.startcheck.innerHTML='开始可以使用!';")
    end
  end
  def check_end_num
    name = params[:name]
    x = params[:x]
    stn = JfBase.check_end_num(name,x)
    if stn.size>0
      render :text => js("parent.endcheck.innerHTML='#{x}不可以使用';")
    else
      render :text => js("parent.endcheck.innerHTML='结束可以使用!';")
    end
  end
  
  def record_visit_count(key)
    REDIS_DB["#{key}"] = REDIS_DB["#{key}"].to_i + 5 + rand(20)
  end

  def update_firms_time(time,id)
    decofirm = DecoFirm.find(id)
    decofirm.update_attribute(:ordertime , time)
  end
  
  #根据省市编号取得各省市下的地区域Hash
  def get_areas2(cityid) 
    if cityid.to_i == 0
      areas = Hash.new
      return areas    
    end
    
    key = "zhaozhuangxiu_area_1_2009_512_15c_ssz_#{cityid}_Time.now.strftime('%Y%m%d')"
    DecoInfo
    if PUBLISH_CACHE.get(key).nil?
      as = DecoInfo.find(:all, :select => "tagid,tagname", :from => "HEJIA_TAG", :conditions => "tagfatherid = #{cityid}")
      areas = Hash.new
      as.each do |a|
        areas[a.tagid.to_i] = a.tagname
      end
      PUBLISH_CACHE.set(key,areas)
    else
      areas = PUBLISH_CACHE.get(key)
    end
    return areas
  end
  
  def select_area
    @areas = get_areas2(params[:cityid])
    render :partial => "select_area"
  end
  
  def note_list
    if params[:commit] && params[:commit] == "更新"
      update_adjusted_pv
    elsif params[:commit] && params[:commit] == "调整"
      update_adjusted_votes
    else
      @CITIES = CITIES
      @diary_id = params[:diary_id]
      @title = params[:title]
      @companyname = params[:companyname]
      @author = params[:author]
      @status = params[:status]
      @is_verified = params[:is_verified]
      @city = params[:city]
      @price = params[:price]
      @isgood = params[:isgood]
      @model = params[:model]
      @style = params[:style]
      @begintime = params[:begintime]
      @endtime = params[:endtime]
      @vote = params[:vote]
      conditions = ["status != '-1' and status != '2'"]
      conditions << "model = '#{@model}'" if @model && @model.to_i > 0
      conditions << "title like '%#{@title}%'"  if @title && @title != ''
      conditions << " id = #{@diary_id}" if @diary_id && @diary_id.to_i > 0
      conditions << "status = '1'" if @status.to_i == 1 #审核过
      conditions << "status = '0'" if @status.to_i == 2 #没审核
      conditions << "is_verified = '1'" if @is_verified.to_i == 1 #已验证
      conditions << "is_verified = '0'" if @is_verified.to_i == 2 #未验证
      if @author && @author != ''
        user = HejiaUserBbs.find(:first, :conditions => ["USERNAME=?",@author])
        id = user.blank? ? "null" : user.USERBBSID
        conditions << "user_id=#{id}"
      end
      if firms = DecoFirm.find(:all, :conditions => ["name_zh like ?","%#{@companyname}%"])
        # if firms.size > 0
        array =  firms.size > 0 ?  firms.map(&:id).join(',') : "null"
        conditions << "deco_firm_id in (#{array})"
        #  end
      end unless @companyname.blank?
      if @city.to_i == 11910 || @city.to_i == 11905 || @city.to_i == 31959
        firms = DecoFirm.find(:all, :conditions => ["city=#{@city.to_i}"])
        array = firms.map(&:id).join(',')
        conditions << "deco_firm_id in (#{array})"
      end
      if @city.to_i > 0 && @city.to_i != 11910 && @city.to_i != 11905 && @city.to_i != 31959
        firms = DecoFirm.find(:all, :conditions => ["district=#{@city}"])
        array = firms.map(&:id).join(',')
        conditions << "deco_firm_id in (#{array})"
      end
      conditions << "is_good = 1" if @isgood.to_i == 1 #精华
      conditions << "price = #{@price}" if @price.to_i > 0
      conditions << "style = #{@style}" if @style.to_i > 0
      conditions << "created_at >= '#{@begintime}'" if @begintime && @begintime != ''
      conditions << "created_at <= '#{@endtime}'" if @endtime && @endtime != ''
      order = "order_time desc"
      order = "votes_sum desc" if @vote.to_i == 1 #已验证
      order = "votes_current_month desc" if @vote.to_i == 2 #未验证
      @notes = DecorationDiary.paginate :page => params[:page], :per_page => 20,:conditions => conditions.join(' and '),:order => order
    end
  end

  def diary_posts_show
    @state = params[:state]
    @diary = DecorationDiary.find(params[:diaryid])
    if @state.to_i == 1
      @posts = @diary.verified_diary_posts
    elsif @state.to_i == 2
      @posts = @diary.unverified_diary_posts
    else
      @posts = @diary.decoration_diary_posts
    end
  end
  def diary_post_content
    @post = DecorationDiaryPost.find(params[:post_id]).body
  end

  #修改日记内容状态
  def post_update
    if staff_logged_in?
      id = getselectid
      DecorationDiaryPost.update_all("state = true, updated_at = '#{Time.now.utc.to_s(:db)}'", "id in (#{id})")
      diary = DecorationDiary.find params[:diaryid]
      DecorationDiary.update_all("order_time = '#{diary.verified_diary_posts.first.created_at.to_s(:db)}'","id = #{params[:diaryid]}")
      redirect_to :action => 'diary_posts_show',:diaryid => params[:diaryid]
    end
  end
  def post_update_quxiaoshenhe
    if staff_logged_in?
      id = getselectid
      DecorationDiaryPost.update_all("state = false, updated_at = '#{Time.now.utc.to_s(:db)}'", "id in (#{id})")
      redirect_to :action => 'diary_posts_show',:diaryid => params[:diaryid]
    end
  end

  #修改
  def note_edit
    @note = DecorationDiary.find(params[:id])
    if request.post?
      @note.title = params[:title]
      @note.content = params[:content]
      @note.created_at = params[:date] if params[:date] && params[:date] != ''
      @note.room = params[:room]
      @note.price = params[:price]
      @note.model = params[:methodtype]
      @note.style = params[:style]
      @note.last_updater = cuurent_staff.id
      @note.save
      render :text => '修改成功'
    end
  end

  #删除
  def note_delete
    if staff_logged_in?
      id = getselectid
      #DecorationDiary.update_all("status = '-1'", "id in ( #{id} )"),既然是删除那就直接干掉好了
      id.split(",").each do |diary_id|
        diary = DecorationDiary.find_by_id diary_id
        if diary
          city = diary.deco_firm.city == 11910 ? diary.deco_firm.city : diary.deco_firm.district
          PUBLISH_CACHE.delete("DecorationDiary/#{diary.deco_firm_id}/#{diary_id.to_i}/#{city}")
          if diary.deco_firm && (diary.deco_firm.city == "11910" || diary.deco_firm.city == "11905" || diary.deco_firm.city == "31959")
            CACHE.delete("notes/list/#{diary.deco_firm.city}////////1/")
          elsif diary.deco_firm && diary.deco_firm.district
            CACHE.delete("notes/list/#{CITIES[diary.deco_firm.district.to_i]}////////1/")
          end
          diary.destroy
        end
      end
      redirect_to :action => 'note_list',:title => params[:title],:companyname => params[:companyname],:status => params[:status],:page => params[:page],:city => params[:city],:price => params[:price],:isgood => params[:isgood],:begintime => params[:begintime],:endtime => params[:endtime],:vote => params[:vote],:style => params[:style]
    end
  end
  
  #验证
  def note_derified
    if staff_logged_in?
      id = getselectid
      DecorationDiary.update_all("is_verified = '1', updated_at = '#{Time.now.utc.to_s(:db)}'","id in (#{id})")
      redirect_to :action => 'note_list',:title => params[:title],:companyname => params[:companyname],:status => params[:status],:page => params[:page],:city => params[:city],:price => params[:price],:isgood => params[:isgood],:begintime => params[:begintime],:endtime => params[:endtime],:vote => params[:vote],:style => params[:style]
    end
  end
  #取消验证
  def note_quxiao_derified
    if staff_logged_in?
      id = getselectid
      DecorationDiary.update_all("is_verified = '0'","id in (#{id})")
      redirect_to :action => 'note_list',:title => params[:title],:companyname => params[:companyname],:status => params[:status],:page => params[:page],:city => params[:city],:price => params[:price],:isgood => params[:isgood],:begintime => params[:begintime],:endtime => params[:endtime],:vote => params[:vote],:style => params[:style]
    end
  end
  #完结
  def note_finished
    id = getselectid
    DecorationDiary.update_all("finished = '1', updated_at = '#{Time.now.utc.to_s(:db)}'","id in (#{id})")
    redirect_to :action => 'note_list',:title => params[:title],:companyname => params[:companyname],:status => params[:status],:page => params[:page],:city => params[:city],:price => params[:price],:isgood => params[:isgood],:begintime => params[:begintime],:endtime => params[:endtime],:vote => params[:vote],:style => params[:style]
    
  end
  
  def note_not_finished
    id = getselectid
    DecorationDiary.update_all("finished = '0', updated_at = '#{Time.now.utc.to_s(:db)}'","id in (#{id})")
    redirect_to :action => 'note_list',:title => params[:title],:companyname => params[:companyname],:status => params[:status],:page => params[:page],:city => params[:city],:price => params[:price],:isgood => params[:isgood],:begintime => params[:begintime],:endtime => params[:endtime],:vote => params[:vote],:style => params[:style]
    
  end
  
  #修改状态
  def note_update
    if staff_logged_in?
      id = getselectid
      DecorationDiary.update_all("status = '1',updated_at = '#{Time.now.utc.to_s(:db)}'", "id in (#{id})")
      redirect_to :action => 'note_list',:title => params[:title],:companyname => params[:companyname],:status => params[:status],:page => params[:page],:city => params[:city],:price => params[:price],:isgood => params[:isgood],:begintime => params[:begintime],:endtime => params[:endtime],:vote => params[:vote],:style => params[:style]
    end
  end
  
  #日记关联案例页面
  def note_relate_to_case_index
    flash[:error] = params[:info] if params[:info]
    @decoration_diary = DecorationDiary.find(params[:diary_id], :include => [:hejia_case])
  end
  
  #日记关联案例
  def note_relate_to_case
    @decoration_diary = DecorationDiary.find_by_id(params[:diary_id])
    @case = HejiaCase.find_by_ID(params[:case_id]) 
    if @decoration_diary.hejia_case
      if @case.nil?
        @decoration_diary.hejia_case.update_attribute("decoration_diary_id" , nil)
        case_info = "案例关联已取消"
      else
        @decoration_diary.hejia_case.update_attribute("decoration_diary_id" , nil)
        @case.update_attribute("decoration_diary_id" , @decoration_diary.id)
        case_info = "关联案例已更新为-->#{@case.id}"
      end
    else
      if @case.nil? || @case.firm.id != @decoration_diary.deco_firm.id
        case_info = "错误:案例不存在或不属于此公司"
      else
        @case.update_attribute("decoration_diary_id" , @decoration_diary.id)
        case_info = "关联案例-->#{@case.id}"
      end
    end
    redirect_to :action => 'note_relate_to_case_index', :info => case_info, :diary_id => @decoration_diary.id
  end
  
  #取消审核
  def note_update_quxiaoshenhe
    if staff_logged_in?
      id = getselectid
      DecorationDiary.update_all("status = '0', updated_at = '#{Time.now.utc.to_s(:db)}'", "id in (#{id})")
      redirect_to :action => 'note_list',:title => params[:title],:companyname => params[:companyname],:status => params[:status],:page => params[:page],:city => params[:city],:price => params[:price],:isgood => params[:isgood],:begintime => params[:begintime],:endtime => params[:endtime],:vote => params[:vote],:style => params[:style]
    end
  end
  #精华并且审核
  def note_jinghua_shenhe
    if staff_logged_in?
      id = getselectid
      DecorationDiary.update_all("is_good = '1', status = '1', updated_at = '#{Time.now.utc.to_s(:db)}'", "id in (#{id})")
    end  
    redirect_to :action => 'note_list',:title => params[:title],:companyname => params[:companyname],:status => params[:status],:page => params[:page],:city => params[:city],:price => params[:price],:isgood => params[:isgood],:begintime => params[:begintime],:endtime => params[:endtime],:vote => params[:vote],:style => params[:style]
  end
  
  def see_user
    @user = HejiaUserBbs.find_by_USERBBSID(params[:id])
    @backuser = User.find(@user.user_id) if @user.user_id.to_i > 0
    if @backuser && @backuser.id
      result = "#{@user.USERNAME} -- #{@backuser.rname}"
    else
      result = @user.USERNAME
    end
    render :text => result
  end
  
  #精华
  def note_jinghua
    if staff_logged_in?
      id = getselectid
      DecorationDiary.update_all("is_good = '1'", "id in (#{id})")
      if params[:note] && params[:note][:selected_ids]
        params[:note][:selected_ids].each do |diary_id|
          diary = DecorationDiary.find(diary_id)
          if diary and diary.deco_firm
            diary.deco_firm.update_attributes(:diaries_verified_count => diary.deco_firm.diaries_verified_count + 1)
          end
        end
      end
      redirect_to :action => 'note_list',:title => params[:title],:companyname => params[:companyname],:status => params[:status],:page => params[:page],:city => params[:city],:price => params[:price],:isgood => params[:isgood],:begintime => params[:begintime],:endtime => params[:endtime],:vote => params[:vote],:style => params[:style]
    end
  end
  #取消精华
  def note_quxiao_jinghua
    if staff_logged_in?
      id = getselectid
      DecorationDiary.update_all("is_good = '0'", "id in (#{id})")
      if params[:note] && params[:note][:selected_ids]
        params[:note][:selected_ids].each do |diary_id|
          diary = DecorationDiary.find(diary_id)
          if diary and diary.deco_firm
            diary.deco_firm.update_attributes(:diaries_verified_count => diary.deco_firm.diaries_verified_count - 1)
          end
        end
      end
      redirect_to :action => 'note_list',:title => params[:title],:companyname => params[:companyname],:status => params[:status],:page => params[:page],:city => params[:city],:price => params[:price],:isgood => params[:isgood],:begintime => params[:begintime],:endtime => params[:endtime],:vote => params[:vote],:style => params[:style]
    end
  end
  
  def getselectid
    result = '0'
    if params[:note] && params[:note][:selected_ids]
      params[:note][:selected_ids].each do |id|
        result = result + ','+ id
      end
    end
    return result
  end
  
  def delete_all
    ids = params[:ids]
    if ids.right(ids,0).to_s == ","
      id = ids.left(ids, ids.length-1)
    else
      id = ids
    end
    begin
      Remark.destroy_all("id in (#{params[:ids]})")
    rescue
      logger.error("错误信息 (review_controller) action(delete_all) params=#{id}")
    end
    redirect_to flash[:previous_url] #request.env["HTTP_REFERER"]
  end
  #修改日记的设计、施工、服务三个分数 //6月12号，张春明
  def update_diary_praise
    @diary = DecorationDiary.find params[:diaryid]
    if request.post?
      @diary.praise = params[:praise]
      @diary.design_praise = params[:design_praise]
      @diary.construction_praise = params[:construction_praise]
      @diary.service_praise = params[:service_praise]
      @diary.save
      @message = "修改成功"
    end
  end

  #修改已合作的商家的合作时间firmid
  def update_cooperation_time
    @firm = DecoFirm.find params[:firmid]
    if request.post?
      @firm.cooperation_time = params[:cooperation_time]
      @firm.save
      @message = "修改成功"
    end
  end

  def cat_firm_reviews  #查看公司评论
    @firm = DecoFirm.find params[:firmid]
    @user_name = params[:user_name]
    @diary = params[:diary]
    @comment = params[:comment]
    conditions = []
    conditions << "praise<>0 and resource_type='DecoFirm' and resource_id=#{@firm.id}"
    if @user_name
      @user_bbs_id = HejiaUserBbs.find(:first, :conditions => ["USERNAME=?", @user_name])
      conditions << "user_id=#{@user_bbs_id.USERBBSID}"
    end
    conditions << "other_id is not null" if @diary.to_i == 1
    conditions << "other_id is null" if @diary.to_i == 2
    conditions << "content is not null" if @comment.to_i == 1
    conditions << "content is null" if @comment.to_i == 2
    @remarks = Remark.paginate :page => params[:page], :per_page => 30, :conditions => conditions.join(' and '), :order => "id desc"
  end

  # 一日汇总：每日发表评价数（即有评分的）、 每日发表日记数、 每日发表评论数（即普通留言，没评分）、 每日上传案例数 、 每日在建预约数
  #以上数据需要单个公司每天统计数及每个城市的每天总数，且按不同的五个城市分开查询
  def first_summary
    @cname = params[:cname]
    @city = params[:city]
    @price = params[:price]
    @style = params[:style]
    if params[:order].nil? || params[:order] == "0"
      @order = "id asc"
    elsif params[:order] == '1'
      @order = "evaluations desc"
    elsif params[:order] == '2'
      @order = "diaries desc"
    elsif params[:order] == '3'
      @order = "cases desc"
    elsif params[:order] == '4'
      @order = "comments desc"
    elsif params[:order] == '5'
      @order = "registers desc"
    end
    @time =params[:time] || 1.days.ago.strftime("%Y-%m-%d")
    conditions = ["time='#{@time}'"]
    conditions << "name='#{@cname}'" if @cname
    conditions << "city=#{@city.to_i}" if @city.to_i > 0
    conditions << "price=#{@price.to_i}" if @price.to_i > 0
    conditions << "style=#{@style.to_i}" if @style.to_i > 0
    if @city.to_i > 0
      @city_summary = CityFirstSummary.find(:first, :conditions => ["city=? and time=?", @city.to_i, @time])
    else
      @city_summary = CityFirstSummary.find(:all, :conditions => ["time=?", @time])
    end
    @firms = FirmFirstSummary.paginate :page => params[:page], :per_page => 30, :conditions => conditions.join(' and '), :order => @order
  end

  def cat_mobile_verify
    @mob_tel = params[:mob_tel]
    @user_name = params[:user_name]
    @is_verified = params[:is_verified]
    @begintime = params[:begintime]
    @endtime = params[:endtime]
    conditions = []
    conditions << "id > 0"
    conditions << "user_mobile=#{@mob_tel}" if @mob_tel
    if @user_name
      user = HejiaUserBbs.find_by_USERNAME(@user_name)
      conditions << "user_id=#{user.USERBBSID}" if user
    end
    conditions << "verify_status=0" if @is_verified.to_i == 2
    conditions << "verify_status=1" if @is_verified.to_i == 1
    conditions << "created_at >= '#{@begintime}'" if @begintime && @begintime != ''
    conditions << "created_at < '#{(@endtime.to_date + 1).to_s}'" if @endtime && @endtime != ''
    @mobile_code_verifis = MobileCodeVerify.paginate :page => params[:page], :per_page => 30, :conditions => conditions.join(' and '), :order => "id desc"
  end

  #后台案例管理
  def case_list
    @case_id = params[:case_id]
    @case_title = params[:case_title]
    @firm_id = params[:firm_id]
    @firm_name = params[:firm_name]
    conditions = ["COMPANYID <> 7"]
    conditions << "ID=#{@case_id}" if @case_id.to_i > 0
    conditions << "NAME='#{@case_title}'" unless @case_title.blank?
    conditions << "COMPANYID=#{@firm_id}" if @firm_id.to_i > 0
    firm = DecoFirm.find_by_name_zh @firm_name if @firm_name
    conditions << "COMPANYID=#{firm.id}" if firm
    @cases = HejiaCase.paginate :page => params[:page], :per_page => 20, :conditions => conditions.join(' and '), :order => "CREATEDATE desc"

  end

  def cases_destroy
    HejiaCase.delete_all(["id in (?)", params[:case_ids].split(",")])
    redirect_to request.env["HTTP_REFERER"]
  end

  def remark_reply_manage
    @replies = Remark.find(params[:remark_id]).replies.paginate :page => params[:page], :per_page => 20, :order => "created_at desc"
  end

  def reply_destroy
    Remark.delete_all(["id in (?)", params[:reply_ids].split(",")])
    redirect_to request.env["HTTP_REFERER"]
  end

  def diary_posts_list
    @CITIES = {
      11910 => "上海", 12117 => "苏州", 12122 => "南京", 12301 => "宁波", 12306 => "杭州", 12118 => "无锡",
      12093 => '武汉', 12122 => "南京", 12173 => '青岛', 12109 => '长沙', 11921 => '合肥', 12059 => '郑州',
      11905 => '北京', 31959 => '广州', 11971 => '深圳', 12243 => '成都', 11944 => '厦门', 12013 => '海口'
    }
    @diary_id = params[:diary_id]
    @title = params[:title]
    @companyname = params[:companyname]
    @author = params[:author]
    @state = params[:state]
    @city = params[:city]
    @begintime = params[:begintime]
    @endtime = params[:endtime]
    if @state.to_i == 1
      conditions = ["state=0"]
    elsif @state.to_i == 2
      conditions = ["marker=1"]
    else
      conditions = ["(state=0 or marker=1)"]
    end
    conditions << ["decoration_diary_id=#{@diary_id}"] if @diary_id && @diary_id.to_i > 0
    if @title && @title != ''
      diary = DecoratoinDiary.find(:first, :conditions => ["title=?",@title])
      conditions << ["decoration_diary_id=#{diary.id}"] if diary
    end
    if @author && @author != ''
      user = HejiaUserBbs.find(:first, :conditions => ["USERNAME=?",@author])
      id = user.blank? ? "null" : user.USERBBSID
      diaries = DecorationDiary.find(:all, :conditions => ["user_id=?",id])
      conditions << ["decoration_diary_id in (#{diaries.map(&:id).join(",")})"] if diaries.size > 0
    end
    if firm = DecoFirm.find(:first, :conditions => ["name_zh = ?",@companyname])
      conditions << "decoration_diary_id in (#{firm.decoration_diaries.map(&:id).join(",")})"
    end unless @companyname.blank?
    if @city.to_i == 11910 || @city.to_i == 11905 || @city.to_i == 31959
      diaries = DecorationDiary.find(:all, :conditions => ["deco_firm_id in (#{DecoFirm.find(:all, :conditions => ["city=#{@city.to_i}"]).map(&:id).join(',')})"])
      conditions << ["decoration_diary_id in (#{diaries.map(&:id).join(",")})"] if diaries.size > 0
    end
    if @city.to_i > 0 && @city.to_i != 11910 && @city.to_i != 11905 && @city.to_i != 31959
      diaries = DecorationDiary.find(:all, :conditions => ["deco_firm_id in (#{DecoFirm.find(:all, :conditions => ["district=?",@city]).map(&:id).join(',')})"])
      conditions << ["decoration_diary_id in (#{diaries.map(&:id).join(",")})"] if diaries.size > 0
    end
    conditions << "created_at >= '#{@begintime}'" if @begintime && @begintime != ''
    conditions << "created_at <= '#{@endtime}'" if @endtime && @endtime != ''
    @posts = DecorationDiaryPost.paginate :page => params[:page], :per_page => 20, :conditions => conditions.join(' and '), :order => "updated_at desc"
  end

  def posts_list_update
    if staff_logged_in?
      id = getselectid
      DecorationDiaryPost.update_all("state = true, updated_at = '#{Time.now.utc.to_s(:db)}'", "id in (#{id})")
      params[:note][:selected_ids].each do |post_id|
        diary = DecorationDiaryPost.find(post_id).decoration_diary
        DecorationDiary.update_all("order_time = '#{diary.verified_diary_posts.first.created_at.to_s(:db)}'","id = #{diary.id}")
      end
      redirect_to :action => 'diary_posts_list',:title => params[:title],:companyname => params[:companyname],:state => params[:state],:page => params[:page],:city => params[:city],:begintime => params[:begintime],:endtime => params[:endtime],:diary_id => params[:diary_id]
    end
  end

  def radmin_case_edit
    @cities = Tag.provinces_to_hash
    @id = params[:id].to_i
    @case = DecoCase.find @id
    @deco_company_id = @case.COMPANYID
    @tag1 = DecoInfo.find(:all, :select => "tagid,tagname", :from => "HEJIA_TAG", :conditions => "tagfatherid = 4350 and TAGESTATE!='-1'")#装修方式
    @tag2 = DecoInfo.find(:all, :select => "tagid,tagname", :from => "HEJIA_TAG", :conditions => "tagfatherid = 4349 and TAGESTATE!='-1'")#费用
    @tag3 = DecoInfo.find(:all, :select => "tagid,tagname", :from => "HEJIA_TAG", :conditions => "tagfatherid = 4348 and TAGESTATE!='-1'")#风格
    @tag4 = DecoInfo.find(:all, :select => "tagid,tagname", :from => "HEJIA_TAG", :conditions => "tagfatherid = 4352 and TAGESTATE!='-1'")#装修用途
    @tag5 = DecoInfo.find(:all, :select => "tagid,tagname", :from => "HEJIA_TAG", :conditions => "tagfatherid = 4347 and TAGESTATE!='-1'")#户型
    @tag6 = DecoInfo.find(:all, :select => "tagid,tagname", :from => "HEJIA_TAG", :conditions => "tagfatherid = 6687 and TAGESTATE!='-1'")#颜色
    # add by sueg for new case manager
    @teshu = DecoInfo.find(:all, :select => "tagid,tagname", :from => "HEJIA_TAG", :conditions => "tagfatherid = 31262 and TAGESTATE!='-1'")#特别选项
    @jiaju = DecoInfo.find(:all, :select => "tagid,tagname", :from => "HEJIA_TAG", :conditions => "tagfatherid = 30885 and TAGESTATE!='-1'")#家居类别
    @anli = DecoInfo.find(:all, :select => "tagid,tagname", :from => "HEJIA_TAG", :conditions => "tagfatherid = 4401 and TAGESTATE!='-1'")#案例类别
    @zixun = DecoInfo.find(:all, :select => "tagid,tagname", :from => "HEJIA_TAG", :conditions => "tagfatherid = 9079 and TAGESTATE!='-1'")#资讯案例
    @leibie = DecoInfo.find(:all, :select => "tagid,tagname", :from => "HEJIA_TAG", :conditions => "tagfatherid = 30885 and TAGESTATE!='-1'")#家居类别
    @chanpin = DecoInfo.find(:all, :select => "tagid,tagname", :from => "HEJIA_TAG", :conditions => "tagfatherid = 41662 and TAGESTATE!='-1'")#产品
    @gonggongkongjian = DecoInfo.find(:all, :select => "tagid,tagname", :from => "HEJIA_TAG", :conditions => "tagfatherid = 42160 and TAGESTATE!='-1'")#公共空间
    @tagids = Array.new
    @designers = Hash.new
    @designers["不选"] = 0
    designers = DecoDesigner.find :all, :select=>"ID as id, DESNAME", :conditions=> "COMPANY = #{@deco_company_id} and status <> '-100'"
    for d in designers
      @designers[d.DESNAME] = d.id.to_i
    end
    tags = DecoInfo.find(:all,:select => "TAGID, STATE",:from => "HEJIA_TAG_ENTITY_LINK",
      :conditions => "ENTITYID = #{@id} and LINKTYPE = 'case'")
    hand_tags = []
    for tag in tags
      hand_tags << Tag.get_tagname_by_tagid(tag.TAGID) if tag.STATE.to_i == 2
    end
    @hand_tags = hand_tags.join(" ")
    @tagids = tags.collect { |r| r.TAGID  }
    @case["PROVINCE2"]  = @case["PROVINCE2"].to_s
    @case["ISNEWCASE"] = @case["ISNEWCASE"].to_i
    @case["ISCHOICENESS"] = @case["ISCHOICENESS"].to_i
    @case["ISCOMMEND"] = @case["ISCOMMEND"].to_i
    @case["ISZHUANGHUANG"] = @case["ISZHUANGHUANG"].to_i
    @case["category"] = @case["category"].to_i
    if @case.PROVINCE1.nil?
      #      @areas = get_areas2(11910)
      firm = @case.deco_firm
      if firm && firm.city.to_i > 0
        @areas = get_areas2(firm.city)
      else
        @areas = get_areas2(11910)
      end
    else
      @areas = get_areas2(@case.PROVINCE1)
    end
    @case_detail = HejiaCase.find(params[:id]).case_detail
  end

  def case_edit_save
    case_id = params[:id].to_i
    c = params[:case]
    begin
      ar = DecoCase.find case_id, :select=>"ID, NAME, COMPANYID, INTRODUCE,HOSTINFO,BUILDINGNAME,HOUSEAREA, STATUS, DESIGNERID, ISNEWCASE, ISCHOICENESS, ISCOMMEND, ISZHUANGHUANG,HUXINGORDER,YUSUANORDER,FENGGEORDER,YONGTUORDER,BUILDINGNAME,address,PROVINCE2,matrial,PROVINCE1,category"
      ar.update_attributes(c)
      # delete memcache
      PHOTO_CACHE.set("key_photo_show_hejia_case_#{case_id}",nil)
      PHOTO_CACHE.set("key_photo_show_photos_tag_#{case_id}",nil)
      HejiaTagLink.delete_all "ENTITYID = #{case_id} and LINKTYPE = 'case'"
      rt = alert("操作成功：信息已修改!")
      @case_detail = CaseDetail.find_by_hejia_case_id(ar.ID)
      if @case_detail.nil?
        params[:case_detail][:hejia_case_id] = ar.ID
        CaseDetail.create(params[:case_detail])
      else
        @case_detail.update_attributes(params[:case_detail])
      end
      hand_tags = params[:hand_tags].gsub(","," ").gsub(";"," ").gsub("，"," ").gsub("；"," ").gsub("  "," ")
      hand_tags = trim(hand_tags).split(" ")
      hand_tags.each do |tagname|
        tag_id = Tag.get_tagid_by_tagname(tagname)
        create_tag_link(case_id, tag_id, "case", 2) unless tag_id == 0
      end
      create_tag_link(case_id, params[:tag1], "case") unless params[:tag1].nil?
      unless params[:tag2].nil?
        params[:tag2].each do |tagid|
          create_tag_link(case_id, tagid, "case")
        end
      end
      unless params[:tag3].nil?
        params[:tag3].each do |tagid|
          create_tag_link(case_id, tagid, "case")
        end
      end
      unless params[:tag4].nil?
        params[:tag4].each do |tagid|
          create_tag_link(case_id, tagid, "case")
        end
      end
      unless params[:tag5].nil?
        params[:tag5].each do |tagid|
          create_tag_link(case_id, tagid, "case")
        end
      end
      unless params[:tag6].nil?
        params[:tag6].each do |tagid|
          create_tag_link(case_id, tagid, "case")
        end
      end
      unless params[:teshu].nil?
        params[:teshu].each do |tagid|
          create_tag_link(case_id, tagid, "case")
        end
      end
      create_tag_link(case_id, params[:anli], "case") unless params[:anli].nil?
      create_tag_link(case_id, params[:zixun], "case") unless params[:zixun].nil?

      unless params[:leibie].nil?
        params[:leibie].each do |tagid|
          create_tag_link(case_id, tagid, "case")
        end
      end

      unless params[:chanpin].nil?
        params[:chanpin].each do |tagid|
          create_tag_link(case_id, tagid, "case")
        end
      end

      unless params[:gonggongkongjian].nil?
        params[:gonggongkongjian].each do |tagid|
          create_tag_link(case_id, tagid, "case")
        end
      end
    rescue Exception => e
      rt = alert("操作失败：#{get_error(e)}")
    end
    render :text => rt
  end
  
end
