class FormController < ApplicationController

  def change_status
    return false unless pvalidate("修改表单状态","管理员","表单管理")
    Form.update_all("status = #{params[:status]}", "id in (#{params[:ids]})") unless params[:ids].nil?
    render :text => js(top_load("self"))
  end

  def change_data_status
    return false unless pvalidate("修改表单数据状态","管理员","表单管理")
    if params[:status].to_i == 1
      Fdata.update_all("status = #{params[:status]}, ptime = now(), area = '#{params[:area]}', remark = '#{params[:remark]}'", "id in (#{params[:ids]})") unless params[:ids].nil?
    else
      Fdata.update_all("status = #{params[:status]}", "id in (#{params[:ids]})") unless params[:ids].nil?
    end
    render :text => js(top_load("self"))
  end

  def data
    return false unless pvalidate("浏览表单数据","管理员","表单管理")
    @city = params[:city]
    @pagesize = 15 #每页记录数
    @listsize = 10 #同时显示的页码数
    @status = params[:status]
    @riqi1 = params[:riqi1]
    @riqi2 = params[:riqi2]
    condition = "formid = #{params[:id]} and isdelete = 0"
    condition += " and status = #{@status}" if pp(@status)
    condition += " and cdate >= '#{@riqi1}'" if pp(@riqi1)
    condition += " and cdate <= '#{@riqi2}'" if pp(@riqi2)
    condition += " and c8 = '#{@city}'" if pp(@city)
    if params[:page].nil?
      @curpage = 1
    else
      @curpage = params[:page].to_i
    end
    if params[:recordcount].nil?
      @recordcount = Fdata.count("id", :conditions => condition)
    else
      @recordcount = params[:recordcount].to_i
    end
    @pagecount = (1.0 * @recordcount / @pagesize).ceil

    @fdatas = Fdata.find :all,
      #:select => "id, title, cnum, forward, remark, udate, status",
    :conditions => condition,
      :offset => @pagesize * (@curpage - 1),
      :limit => @pagesize,
      :order => "id desc"
    form = Form.find(params[:id],:select=>"title,department")
    unless current_staff.admin?
      if form.department.to_i != 0 and form.department.to_i != current_staff.department
        render :text => "你无权访问非本部门信息!"
        return false
      end
    end
    @title = form.title
    @columns = Column.find :all, :select => "id, sn, cname, ctype, ovalue, dvalue, remark", :conditions => "formid = #{params[:id]}"
  end

  def data_all
    return false unless pvalidate("浏览表单数据","管理员","表单管理")
    @pagesize = 15 #每页记录数
    @listsize = 10 #同时显示的页码数
    @status = params[:status]
    @riqi1 = params[:riqi1]
    @riqi2 = params[:riqi2]
    conditions = []
    conditions << "d.isdelete = 0 and f.isdelete = 0 and d.formid = f.id and f.title not like '%评论'"
    conditions << "status = #{@status}" if pp(@status)
    conditions << "cdate >= '#{@riqi1}'" if pp(@riqi1)
    conditions << "cdate <= '#{@riqi2}'" if pp(@riqi2)

    department = current_staff.department
    unless current_staff.admin?
      if department == 0
        conditions << "f.department = 0"
      else
        conditions << "f.department in (0, #{department})"
      end
    end

    @fdatas = paging_record options = {
      "model" => Fdata,
      "pagesize" => 15,   #每页记录数
      "listsize" => 10,  #同时显示的页码数
      "primary_key" => "d.id",
      "select" => "d.*, f.title as tt",
      "joins" => "d, radmin_forms f",
      "conditions" => conditions.join(" and "),
      "order" => "d.id desc"
    }
  end

  def data_del
    return false unless pvalidate("删除表单数据","管理员","表单管理")
    begin
      Fdata.update(params[:id], :isdelete => 1) unless params[:id].nil?
      Fdata.update_all("isdelete = 1", "id in (#{params[:ids]})") unless params[:ids].nil?
      render :text => js(top_load("self"))
    rescue Exception => e
      render :text => alert_error("操作失败：#{get_error(e)}")
    end
  end

  def preview
    return false unless pvalidate("表单预览")
    @f_ctype = FORM_CTYPE.split(",")   #表单字段分类
    @columns = Column.find :all,
      :select => "id, sn, cname, ctype, ovalue, dvalue, remark, mustfill",
      :conditions => "formid = #{params[:id]}",
      :order => "sn asc"
    @title = Form.find(params[:id],:select=>"title").title
    render :layout => false
  end

  def code
    return false unless pvalidate("表单代码")
    @f_ctype = FORM_CTYPE.split(",")   #表单字段分类
    @columns = Column.find :all,
      :select => "id, sn, cname, ctype, ovalue, dvalue, remark, mustfill",
      :conditions => "formid = #{params[:id]}",
      :order => "sn asc"
    @title = Form.find(params[:id],:select=>"title").title
    render :layout => false
  end

  def getFileName(filename)
    filename = filename.downcase
    newname = Time.now.strftime("%Y_%m_%d_%H_%M_%S")
    return newname + ".jpg" if filename.include?(".jpg")
    return newname + ".gif" if filename.include?(".gif")
    return newname + ".png" if filename.include?(".png")
    return newname + ".bmp" if filename.include?(".bmp")
  end
  private :getFileName

  #某表单某字段数值递增
  #调用样例： /form/form_data_increase?form_data_id=83290&column_name=c3  返回值： callback('c3', 8);
  def form_data_increase
    #http://test.51hejia.com:3001/form/form_data_increase?form_data_id=83290&column_name=c2
    form_data_id = params[:form_data_id].to_i
    column_name = params[:column_name]
    extent = params[:extent] && params[:extent].to_i || 1 #递增幅度，默认是1
    @error = '参数form_data_id和column_name都不能为空!' if form_data_id == 0 || column_name.blank?
    fd = Fdata.find(:first, :select => "id, formid, #{column_name}", :conditions => ['id = ?', form_data_id])
    fd[column_name] = fd[column_name].to_i + extent
    fd.save
    key = "wanneng_form_datas_#{fd.formid}"
    CACHE.delete(key) #删除缓存
    if @error
      render :text => @error.to_s
    else
      callback = params[:callback] || 'callback'
      render :json => "#{callback}('#{column_name}', #{fd[column_name]});"
    end
  end

  def form_save(rv="", load_url=nil)
    has_error = false
    formid = params[:formid].to_i
    @forward = "http://www.51hejia.com/"
    if formid > 0
      fi = Form.find(formid,:select=>"id, forward, alert as a, submit_interval")
      submit_interval = fi.submit_interval.to_i
      already_submit = cookies["hejia_already_submit_form_#{formid.to_s}"]
      if already_submit.nil? || submit_interval == 0 || (request.remote_ip == "58.246.26.58" && params[:allow_repeat_in_hejia])
        fd = Fdata.new
        fd.isdelete = 0
        fd.formid = formid
        fd.userip = request.remote_ip
        fd.cdate = getnow
        fd.udate = getnow
        1.upto(35) do |i|
          key = :"c#{i}"
          next unless params.has_key?(key) && !(value = params[key]).blank?
          if [:original_filename, :read].all? { |m| value.respond_to? m }
            #如果是上传文件
            unless value.original_filename.blank?
              #有接收到文件
              filename = getFileName(value.original_filename)
              filepath = "#{RAILS_ROOT}/public/uploads/form_images/#{filename}"
              File.open(filepath, "wb") { |f| f.write value.read }
              fd.send :"#{key}=",  filename
            end
          else
            #如果是普通的表单对象
            fd.send :"#{key}=", fp(value)
          end
        end
        fd.save
        CACHE.delete("wanneng_form_recordcount_#{fd.formid}")
        CACHE.delete("wanneng_form_sum_#{fd.formid}")
        CACHE.delete("wanneng_form_datas_#{fd.formid}")
        js_alert = fi.a unless fi.a.blank?
        (@forward = params[:forward] || fi.forward).strip!
        #%r'^http://' === forward and forward << "?f=#{fd.id}"
        cookies["hejia_already_submit_form_#{formid.to_s}"] = {:value => "y", :expires => submit_interval.minutes.from_now }
      else
        has_error = true
        js_alert = "对不起，您不能在短时间内重复提交同一个表单。"
      end

    else
      has_error = true
      js_alert = "操作错误：参数不足！"
    end
    
    if params[:by_jsonp]
      if has_error
        jsonp_callback = "#{params[:callback]}(0);"
      else
        jsonp_callback = "#{params[:callback]}(1);"
      end
      render :text => jsonp_callback
    else
      myrender js_alert, @forward
    end
    
  end


  def form_tousu_save
    @cb = params[:callback] ? params[:callback] : ''
    unless cookies[:dianping_toushu]
      if request.get? && params[:a]
        @ps = DianpingPiaoshu.find(:first,:conditions =>['choice = ?',params[:a]])
        if @ps
          @ps.update_attribute('piaoshu',@ps.piaoshu + 1)
          cookies[:dianping_toushu] = {:value =>'toushu',:expires =>3.days.from_now}
          @tp = DianpingPiaoshu.find(:all,:conditions =>["id in (?)",%w(1 2 3 4 5)],:select =>'id,piaoshu')
          render :text =>@cb + '(' + @tp.to_json + ')'
        end
      end
    else
      render :text =>@cb +'('+{:commited =>'submited'}.to_json + ')'
    end
  end

  def new
    return false unless pvalidate("新建表单","管理员","表单管理")
    @cnum = 0
    @forward = "http://www.51hejia.com"
    @status = 1
  end

  def new_save
    return false unless pvalidate("保存新建表单","管理员","表单管理")
    begin
      form = Form.new
      form.status = params[:status]
      form.title = trim(params[:title])
      form.forward = trim(params[:forward]) if pp(params[:forward])
      form.remark = trim(params[:remark]) if pp(params[:remark])
      form.department = params[:department].to_i
      form.submit_interval = params[:submit_interval].to_i
      form.alert = params[:alert].to_s
      form.cdate = getnow()
      form.udate = getnow()
      form.save
      render :text => alert("操作成功：新表单已创建!") + js(top_load("self"))
    rescue Exception => e
      render :text => alert_error("操作失败：#{get_error(e)}")
    end
  end

  def edit
    return false unless pvalidate("编辑表单信息","管理员","表单管理")
    form = Form.find(params[:id],:select=>"cnum,status,alert as a,title,submit_interval,forward,remark,department")
    @cnum = form.cnum
    @status = form.status.to_i
    @alert = form.a.to_s
    @title = form.title if pp(form.title)
    @submit_interval = form.submit_interval.to_i
    @forward = form.forward if pp(form.forward)
    @remark = form.remark if pp(form.remark)
    @department = form.department.to_i
  end

  def edit_save
    return false unless pvalidate("保存编辑表单信息","管理员","表单管理")
    form = Form.find(params[:id])
    if current_staff.admin? || form.department.to_i == params[:department].to_i
      begin
        form.status = params[:status]
        form.title = trim(params[:title])
        form.forward = trim(params[:forward])
        form.remark = trim(params[:remark])
        form.department = params[:department].to_i
        form.submit_interval = params[:submit_interval].to_i
        form.alert = params[:alert].to_s
        form.udate = getnow()
        form.save
        render :text => alert("操作成功：表单信息已经保存!") + js(top_load("self"))
      rescue Exception => e
        render :text => alert_error("操作失败：#{get_error(e)}")
      end
    else
      render :text => alert_error("操作失败：只有管理员有权利修改表单所属部门!")
    end
  end

  def list
    return false unless pvalidate("浏览表单列表","管理员","表单管理")
    @status = params[:status]
    department = current_staff.department
    conditions = []
    conditions << "isdelete = 0"
    conditions << "status = #{@status}" if pp(@status)
    unless current_staff.admin?
      if department == 0
        conditions << "department = 0"
      else
        conditions << "department in (0, #{department})"
      end
    end
    @forms = paging_record options = {
      "model" => Form,
      "pagesize" => 15,   #每页记录数
      "listsize" => 10,  #同时显示的页码数
      "select" => "id, title, cnum, department, forward, remark, udate, status",
      "conditions" => conditions.join(" and "),
      "order" => "id desc"
    }
  end

  def del
    return false unless pvalidate("删除表单","管理员","表单管理")
    begin
      Form.update(params[:id], :isdelete => 1) unless params[:id].nil?
      Form.update_all("isdelete = 1", "id in (#{params[:ids]})") unless params[:ids].nil?
      render :text => js(top_load("self"))
    rescue Exception => e
      render :text => alert_error("操作失败：#{get_error(e)}")
    end
  end

  def column_list
    return false unless pvalidate("显示字段列表","管理员","表单管理")
    @f_ctype = FORM_CTYPE.split(",")   #表单字段分类
    @columns = Column.find :all,
      :select => "id, sn, cname, ctype, ovalue, dvalue, remark, mustfill",
      :conditions => "formid = #{params[:id]}",
      :order => "sn asc"
    @title = Form.find(params[:id],:select=>"title").title
    if pp(params[:c_id])
      #编辑记录
      @c_id = params[:c_id].to_i
      c = Column.find(@c_id)
      @sn = c.sn
      @ctype = c.ctype
      @cname = c.cname
      @ovalue = c.ovalue
      @dvalue = c.dvalue
      @remark = c.remark
      @mustfill = c.mustfill
      @sep_type = c.sep_type
      @sep_value = c.sep_value
    else
      #新建记录
      @c_id = 0
      @sn = 1
      for c in @columns
        @sn = @sn + 1 if c.sn == @sn
      end
      @ctype = 0
      @mustfill = false
      @sep_type = nil
      @sep_value = nil
    end
  end

  def column_save
    if params[:c_id].to_i == 0
      rv = Column.column_new_save(params[:cname],params[:sn],params[:ctype],params[:ovalue],params[:dvalue],params[:remark],params[:mustfill],params[:f_id],params[:sep_type],params[:sep_value])
      Form.update_cnum(params[:f_id].to_i)
    else
      rv = Column.column_edit_save(params[:cname],params[:sn],params[:ctype],params[:ovalue],params[:dvalue],params[:remark],params[:mustfill],params[:c_id],params[:sep_type],params[:sep_value])
    end
    if pp(rv)
      render :text => alert_error("操作失败：#{rv}")
    else
      render :text => js(top_load("self"))
    end
  end

  def column_del
    return false unless pvalidate("删除字段","管理员","表单管理")
    begin
      Column.delete(params[:id]) unless params[:id].nil?
      Column.delete_all "id in (#{params[:ids]})" unless params[:ids].nil?
      Form.update_cnum(params[:f_id].to_i)
      render :text => js(top_load("self"))
    rescue Exception => e
      render :text => alert_error("操作失败：#{get_error(e)}")
    end
  end

  def model
    render :layout => false
  end
  
  #装修活动报名情况
  def decohuodong
    @begindate = params[:begindate]
    @enddate = params[:enddate]
    conditions = []
    conditions << "1=1"
    conditions << "created_at > '#{params[:begindate]}'" if params[:begindate]
    conditions << "created_at < '#{params[:enddate]}'" if params[:enddate]
    @baoming = DecoRegister.paginate :page => params[:page],:per_page => 20,:conditions => conditions.join(' and '),:order =>"id desc"
  end
  
  #删除报名信息
  def delhuodong
    DecoRegister.delete(params[:id]) if params[:id]
  end

  def get_data
    mn = params[:mn]
    mn = 'recordcount' if mn.blank?
    send "get_data_#{mn}"
  end

  private

  #取得表单记录总数, 需要参数 form_id
  def get_data_recordcount
    form_id = params[:form_id].to_i
    if form_id > 0
      key = "wanneng_form_recordcount_#{form_id}"
      count = CACHE.fetch(key, 3.hours) do
        Fdata.count("id", :conditions => ["formid=? and isdelete=0", form_id])
      end
    else
      count = 0
    end
    callback = params[:callback] || 'callback'
    render :text => "#{callback}(#{count.to_json});", :content_type => Mime::JS
  end

  #取得表单某些字段所有记录相加总和，需要参数 form_id 和 column_names
  def get_data_sum
    form_id = params[:form_id].to_i
    column_names = params[:column_names].to_s.strip.split(",")
    sums = []
    if form_id > 0 && column_names.length > 0
      key = "wanneng_form_sum_#{form_id}"
      sums = CACHE.fetch(key, 3.hours) do
        column_names.each do |cn|
          sums << Fdata.sum(cn, :conditions => ["formid=? and isdelete=0", form_id])
        end
        sums
      end
    end
    callback = params[:callback] || 'callback'
    render :text => "#{callback}(#{sums.to_json});", :content_type => Mime::JS
  end

  #取得表单某些字段所有记录内容，需要参数 form_id 和 column_names
  #调用样例： /form/get_data?mn=some_columns_data&form_id=157&column_names=c1,c2,c3
  #返回值： callback([["6", "6", "9"]]);
  def get_data_some_columns_data
    form_id = params[:form_id].to_i
    column_names = params[:column_names].to_s.strip.split(",")
    datas = []
    if form_id > 0 && column_names.length > 0
      key = "wanneng_form_datas_#{form_id}"
      datas = CACHE.fetch(key, 3.hours) do
        fdatas = Fdata.find(:all, :select => column_names.join(','), :conditions => ["formid=? and isdelete=0", form_id])
        fdatas.each do |fdata|
          data = []
          column_names.each do |cn|
           data <<  fdata[cn]
          end
          datas << data
        end
        datas
      end
    end
    callback = params[:callback] || 'callback'
    render :text => "#{callback}(#{datas.to_json});", :content_type => Mime::JS
  end


end
