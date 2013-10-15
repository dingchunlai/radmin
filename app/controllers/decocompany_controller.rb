class DecocompanyController < ApplicationController

  $formid = PINGLUN_ID

  #新表deco_firms装修公司后台
  require '_aboutredis.rb'

  
  def index
    @company_id = params[:company_id]   #公司id
    @companyname = params[:companyname]      #公司名字
    @is_cooperation = params[:is_cooperation]   #是否合作商家
    @has_review = params[:has_review]        #是否有评论
    @ordertype = params[:ordertype]          #排序
    @city = params[:city]
    #城市
    @cities = get_cities

    @shangjia = params[:shangjia]#上下架
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
    orders = ""
    if @shangjia && @shangjia!='' && @shangjia.to_s=='4'
      orders = "id desc "
    else
      orders = "comments_count desc,id desc "
    end
    conditions << "name_zh like '%#{@companyname}%'" if @companyname
    conditions << "id = #{@company_id}" if @company_id
    conditions << "is_cooperation = '1'" if @is_cooperation == '1'
    conditions << "(is_cooperation = '0' or is_cooperation is null)" if @is_cooperation == '0'
    conditions << "is_cooperation = '-1'" if  @is_cooperation == '-1'
    conditions << "comments_count > 0"  if @has_review && @has_review == '1'
    conditions << "(comments_count is null or comments_count = 0)"  if @has_review && @has_review == '2'
    conditions << "city = '#{@city}'" if @city && (@city.to_i == 11910 || @city.to_i  == 11905 || @city.to_i == 31959)
    conditions << "district = '#{@city}'" if @city.to_i != 0 && @city.to_i != 11910 && @city.to_i != 11905 && @city.to_i != 31959
    if @shangjia && @shangjia!='' && @shangjia.to_s=='4'
      conditions << "created_at>='2009-11-9'"
    end
    @companys = DecoFirm.paginate :page => params[:page],
      :per_page => 50,
      :conditions => conditions.join(' and '),
      :order => orders

  end

  def get_cities
    CITIES
  end

  #公司添加
  def new
    if request.post?
      companyname = params[:companyname]
      is_cooperation = params[:is_cooperation]

      deco = DecoFirm.find(:first, :conditions=>"name_zh = '#{params[:companyname]}' and state != -100")

      if deco
        @message = "#{companyname}已经存在，请换名"
      else
        decocompany = DecoFirm.new
        decocompany.name_zh = companyname
        decocompany.is_cooperation = is_cooperation
        decocompany.cooperation_time = Time.now if is_cooperation == '1'
        decocompany.state = '000'
        decocompany.created_at = Time.new
        decocompany.updated_at = Time.new
        decocompany.save

        redirect_to :action => 'update',:companyid => decocompany.id
      end
    end
  end

  #公司修改(关联用户)
  def update
    @companyid = params[:companyid]
    @company = DecoFirm.find(@companyid)
    @pv_count = getcompany(@company.id)
    if request.post?
      #合作
      if params[:is_cooperation] == '1'      
        @company.cooperation_time = Time.now if @company.is_cooperation != 1
        @company.is_cooperation = 1
      end
      #合作取消
      if params[:is_cooperation] == '0'
        @company.is_cooperation = 0
        @company.cooperation_time = nil
      end
      #意向
      @company.is_cooperation = -1 if params[:is_cooperation] =='-1'
      @company.bookings_count = params[:bookings_count]
      @company.star_lest = params[:star_lest]
      @company.pv_count = params[:pv_count]
      @pv = updatecompany(@company.id,params[:pv_count])
      @company.updated_at = Time.new
      @company.state = '000' if params[:shangjia] == '1'
      @company.state = '-99' if params[:shangjia] == '0'
      @company.save
      @message = "修改成功"
    end
  end

  #公司逻辑删除
  def delete
    company = DecoFirm.find(params[:companyid])
    company.state = '-100'
    company.save

    redirect_to :action => 'index',:comanyname => params[:companyname],:is_cooperation => params[:is_cooperation]
  end

  #公司逻辑批量删除
  def delete_all_company
    if params[:company] && params[:company][:selected_ids]
      params[:company][:selected_ids].each do |id|
        c = DecoFirm.find(id)
        c.state = '-100'
        c.save
      end
    end

    redirect_to :action => 'index',:comanyname => params[:companyname],:is_cooperation => params[:is_cooperation],:city => params[:city],:page => params[:page]
  end
  #公司逻辑上架
  def shupdate
    company = DecoFirm.find(params[:companyid])
    company.state = '000'
    company.save

    redirect_to :action => 'index',:comanyname => params[:companyname],:is_cooperation => params[:is_cooperation]
  end
  #公司逻辑下架
  def shdown
    company = DecoFirm.find(params[:companyid])
    company.state = '-99'
    company.save

    redirect_to :action => 'index',:comanyname => params[:companyname],:is_cooperation => params[:is_cooperation]
  end
  #刷新公司信息
  def refreshinfo
    if params[:company] && params[:company][:selected_ids]
      params[:company][:selected_ids].each do |id|
        DecoReview.countcompany($formid,id)
      end
    end

    redirect_to :action => 'index',:comanyname => params[:companyname],:is_cooperation => params[:is_cooperation]
  end

  #单独统计
  def refreshbyid
    DecoReview.countcompany($formid,params[:id])
  end

  #公司抽查记录列表，参数公司id
  def recordindex
    @companyid = params[:companyid]
    @records = DecoRecord.find(:all,:conditions => "firm_id = '#{@companyid}'",:order => "id desc")

  end

  #新增抽查记录
  def recordnew
    @companyid = params[:companyid]
    if request.post?
      record = DecoRecord.new
      record.title = params[:title]
      record.summary = params[:summary]
      record.firm_id = params[:companyid]
      record.addpeople = current_staff.id if staff_logged_in?
      record.score = params[:score].to_i
      record.created_at = Time.now
      record.updated_at = Time.now
      record.recorddate = params[:recorddate]
      record.save

      redirect_to :action => 'recordedit',:id => record.id
    end
  end

  #修改抽查记录
  def recordedit
    @id = params[:id]
    @record = DecoRecord.find(@id)
    if request.post?
      @record.title = params[:title]
      @record.summary = params[:summary]
      @record.score = params[:score].to_i
      @record.recorddate = params[:recorddate]
      @record.updated_at = Time.now
      @record.save
    end
  end

  #删除抽查记录
  def recorddelete
    DecoRecord.delete(params[:id])
    redirect_to :action=>'recordindex',:companyid => params[:companyid]
  end

  #刷新公司排名
  def refreshorder
    DecoReview.autoset_firm_order
    redirect_to :action => "index"
  end

  def vedioindex
    @company = DecoFirm.find(params[:companyid])
    @vedios = DecoVedio.find(:all,:conditions => "firm_id = #{params[:companyid]}")
  end

  def vedionew
    @companyid = params[:companyid]
    if request.post?
      vedio = DecoVedio.new
      vedio.title = params[:title]
      vedio.content = params[:content]
      vedio.firm_id = @companyid
      vedio.tuijian = params[:tuijian]
      vedio.created_at = Time.now
      vedio.updated_at = Time.now
      vedio.save

      redirect_to :action => "vedioedit",:id => vedio.id
    end
  end

  def vedioedit
    @id = params[:id]
    @vedio = DecoVedio.find(@id)
    if request.post?
      @vedio.title = params[:title]
      @vedio.content = params[:content]
      @vedio.tuijian = params[:tuijian]
      @vedio.updated_at = Time.now
      @vedio.save
    end
  end

  def vediodelete
    DecoVedio.delete(params[:id])
    redirect_to :action => "vedioindex",:companyid => params[:companyid]
  end

  def sync_geo_address
    DecoFirm.valid_firms.each do |firm|
      if firm.sync_geocode
        logger.info "#{firm.id}'s geocode synced successed."
      else
        logger.info "#{firm.id}'s geocode synced failed."
      end
    end
    flash[:notice] = "地址数据同步成功！"
    redirect_to "/decocompany"
  end

  def test
    host = "192.168.1.12"
    key = "test_zhaozhuangxiu_key"
    db = Redis.new({:host => "#{host}"})
    db.incr("#{key}")
    render :text => db["#{key}"]
  end

  #管理员后台活动报名列表与删除
  def registers_list
    @factory_name = params[:factory_name]
    @company_name = params[:company_name]
    @register_marker = params[:register_marker]
    @marker = params[:marker]
    @state = params[:state]
    @city = params[:city]
    @from_type = params[:from_type]
    @cities = get_cities
    conditions = []
    conditions << "phone is not NULL"
    unless @factory_name.blank?
      factories = DecoFactory.find(:all, :conditions => ["NAME = ?", @factory_name])
      ids = factories.map(&:ID).join(',') 
      ids = ids.size > 0 ? ids : "null"
      conditions << "event_id in (#{ids})"
    end
    unless @company_name.blank?
      company = DecoFirm.find(:first, :conditions => ["name_zh = ?", @company_name])
      ids = company.factories.map(&:ID).join(',') unless company.blank?
      ids = ids.blank? ? "null" : ids
      conditions << "event_id in (#{ids})"
    end
    conditions << "marker like '%#{@register_marker}%'" unless @register_marker.blank?
    conditions << "(marker is null or marker='')" if @marker.to_i == 1
    conditions << "marker is not null and marker<>''" if @marker.to_i == 2
    unless @state.blank?
      conditions << "(state<>'-1' or state is null)" if @state.to_i == 1
      conditions << "state='-1'" if @state.to_i == 2
    end
    unless @city.blank?
      firms = (@city.to_i == 11910 || @city.to_i == 11905 || @city.to_i == 31959) ? DecoFirm.find(:all, :conditions => ["city=?",@city.to_i]) :DecoFirm.find(:all, :conditions => ["district=?",@city.to_i])
      @firms_ids = firms.map(&:id).join(',') unless firms.blank?
      factories = DecoFactory.find(:all, :conditions => ["COMPANYID in (#{@firms_ids})"]) unless @firms_ids.blank?
      ids=factories.map(&:ID).join(',')
      ids = ids.size > 0 ? ids : "null"
      conditions << "event_id in (#{ids})"
    end
    unless @from_type.blank?
      conditions << "from_type = #{@from_type}"
    end
    @registers = DecoRegister.paginate :page => params[:page], :per_page => 20, :conditions => conditions.join(" and "), :order => "created_at desc"
  end

  def update_register_marker
    DecoRegister.update_all("marker = '#{params[:marker]}'", "id = #{params[:register_id]}") unless params[:register_id].blank?
    redirect_to request.env["HTTP_REFERER"]
  end

  def registers_del
    selected_id = params[:registerid] || params[:register][:selected_ids]
    if !selected_id.nil?
      DecoRegister.destroy_all(:id => selected_id)
    end
    redirect_to request.env["HTTP_REFERER"]
  end
  # 添加子公司信息
  def branches
    @firm = DecoFirm.find(:first, :select => "deco_firms.id, deco_firms.city, deco_firms.district, deco_firms.name_zh", :conditions => ["deco_firms.id = ?", params[:firm_id]], :include => :branches)
    city = (@firm.city == 11910 || @firm.city == 11905 || @firm.city == 31959) ? @firm.city : @firm.district
    @tags = Tag.urban_areas city 
  end
  # 保存子公司信息
  def branches_save
    branch = DecoFirmBranch.new(params[:deco_firm_branch])
    branch.deco_firm_id = params[:deco_firm_id]
    branch.service_area = params[:area]
    branch.save
    redirect_to(:action => :branches, :firm_id => params[:deco_firm_id])   
  end
  # 删除子公司信息
  def branch_destroy
    branch = DecoFirmBranch.find_by_id params[:id]
    firm_id = branch.deco_firm_id
    branch.destroy
    redirect_to(:action => :branches, :firm_id => firm_id)
  end

  def edit_firm_info
    unless params[:companyid].blank?
      session['deco_firm_id'] = params[:companyid]
      @firm = DecoFirm.find(params[:companyid])
      @cities = Tag.provinces_to_hash
      @areas = get_areas2(@firm.city.to_i)
      @areas2 = get_areas2(@firm.district.to_i)
    end
  end

  def update_firm_info
    unless params[:firm][:id].blank?
      @firm = DecoFirm.find(params[:firm][:id])
      if (params[:firm][:priority].to_i.to_s == params[:firm][:priority] || params[:firm][:priority].blank?) && @firm.update_attributes((params[:firm]))
        flash[:success] = "企业信息更新成功！"        
        redirect_to request.env["HTTP_REFERER"]
      else
        render :text => alert("更新失败，请按提示填写资料") + js("history.back(-1);")
      end
    end
  end

  def get_areas2(cityid) #取得各地区域Hash
    return {} if cityid.to_i == 0
    as = Tag.find(:all, :select => "TAGID, TAGNAME",  :conditions => "TAGFATHERID = #{cityid}")
    areas = Hash.new
    as.each do |a|
      areas[a.TAGID] = a.TAGNAME
    end
    areas
  end

  def popedom_edit
    @company = DecoFirm.find(params[:companyid])
  end

  def popedom_update
    @company = DecoFirm.find(params[:companyid])
    if @company.update_attribute(:popedom, params[:popedom].to_i)
      flash[:success] = "修改成功"
      redirect_to request.env["HTTP_REFERER"]
    else
      render :text => alert("更新失败!") + js("history.back(-1);")
    end  
  end

  # 关于公司 联系地址
  def contacts
    @deco_firm = DecoFirm.find_by_id params[:company_id]
    return head 404 if @deco_firm.blank?
    @deco_firms_contact = params[:contact_id].blank? ? DecoFirmsContact.new : DecoFirmsContact.find_by_id(params[:contact_id])
  end

  # 修改公司联系地址
  def update_contacts
    unless params[:contact_id].blank?
      contact = DecoFirmsContact.find_by_id params[:contact_id]
      contact.attributes = params[:deco_firms_contact]
      save_contact(contact)
    else
      contact = DecoFirmsContact.new params[:deco_firms_contact] 
      save_contact(contact)
    end
  end

  def destory_contact
    contact = DecoFirmsContact.find_by_id(params[:contact_id])
    if contact.destroy
      flash[:success] = "删除成功！"
      redirect_to request.env["HTTP_REFERER"]
    else
      render :text => alert("操作失败！") + js("history.back(-1);")
    end
  end
  
  # 修改业务员
  def change_firm_for_sales
    @deco_firm = DecoFirm.find_by_id params[:firm_id]
    if @deco_firm.update_attribute(:sales_man_id, params[:sale_id])
      render :text => '绑定业务员成功！'
    else
      render :text => '出错拉！ 请联系管理员'
    end
  end

  #公司预约合同管理 --star
  def applicant_contracts
    @deco_firm = DecoFirm.find_by_id params[:company_id]
    return head 404 if @deco_firm.blank?
    @applicant_contract = params[:applicant_contract_id].blank? ? ApplicantContract.new : ApplicantContract.find_by_id(params[:applicant_contract_id])
  end

  # 修改公司联系地址
  def update_applicant_contract
    unless params[:applicant_contract_id].blank?
      applicant_contract = ApplicantContract.find_by_id params[:applicant_contract_id]
      num = applicant_contract.limit_number
      applicant_contract.attributes = params[:applicant_contract]
      if save_applicant_contract(applicant_contract)
        REDIS_DB.set "firm_#{params[:company_id]}_applicants", REDIS_DB.get("firm_#{params[:company_id]}_applicants").to_i - num + applicant_contract.limit_number
      end
    else
      applicant_contract = ApplicantContract.new params[:applicant_contract]
      if save_applicant_contract(applicant_contract)
        REDIS_DB.set "firm_#{params[:company_id]}_applicants", REDIS_DB.get("firm_#{params[:company_id]}_applicants").to_i + applicant_contract.limit_number
      end
    end
  end
  #--end


  private
  def save_contact(contact)
    if contact.save
      if contact.master?
        contact.resolve_conflict
      end
      flash[:success] = "操作成功！"
      redirect_to request.env["HTTP_REFERER"]
    else
      render :text => alert("操作失败！") + js("history.back(-1);")
    end
  end

  def save_applicant_contract(applicant_contract)
    if applicant_contract.save
      flash[:success] = "操作成功！"
      redirect_to request.env["HTTP_REFERER"]
    else
      render :text => alert("操作失败！") + js("history.back(-1);")
    end
  end
end
