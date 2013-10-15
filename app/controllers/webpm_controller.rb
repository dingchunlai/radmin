class WebpmController < ApplicationController
  before_filter :user_validate, :except => :login #验证用户身份
  
  def new
    return false unless pvalidate("新建参数","管理员","后台维护")
    @webpm = Webpm.new
    @webpm.keyword = params[:keyword]
    @webpm.value = params[:value]
    @webpm.sort = params[:sort]
    @webpm.description = params[:description1]
  end
  def new_save
    return false unless pvalidate("保存新建参数","管理员","后台维护")
    wf = Webpm.find :first, :conditions => "keyword='#{strip(params[:keyword].to_s)}' and sort<>#{params[:sort]}"
    if wf.nil?
      begin
        Webpm.create(
          :keyword => strip(params[:keyword].to_s),
          :value => strip(params[:value].to_s),
          :sort => params[:sort],
          :description => params[:description1],
          :cdate => Time.now,
          :udate => Time.now
        )
        expire_webpm_memcache(params[:keyword])
        render :text => alert("参数添加成功") + js("parent.ge('value').select();")
      rescue Exception => e
        render :text => alert_error(e)
      end
    else
      render :text => alert_error("操作失败：不同的类别里不允许存在相同的关键字参数!")
    end 
  end
  
  def list
    return false unless pvalidate("浏览参数列表")
    @pagesize = 15 #每页记录数
    @listsize = 10 #同时显示的页码数

    condition = "true"
    condition += " and sort = '#{params[:sort]}'" if pp(params[:sort])

    if params[:page].nil?
      @curpage = 1
    else
      @curpage = params[:page].to_i
    end
    if params[:recordcount].nil?
      @recordcount = Webpm.count("id", :conditions => condition)
    else
      @recordcount = params[:recordcount].to_i
    end
    @pagecount = (1.0 * @recordcount / @pagesize).ceil

    @webpms = Webpm.find :all,
      :select => "id, keyword, value, sort, description",
      :conditions => condition,
      :offset => @pagesize * (@curpage - 1),
      :limit => @pagesize,
      :order => "id desc"
	
  end
  
  def edit
    return false unless pvalidate("编辑参数","管理员","后台维护")
    @webpm = Webpm.find :first, :conditions=>["id=#{params[:id]}"] 
    if @webpm.nil?
      render :text => alert_error("未找到相应的记录") + js("history.back();")
    end
  end
  
  def edit_save
    return false unless pvalidate("保存编辑参数","管理员","后台维护")
    wf = Webpm.find :first, :conditions => "keyword='#{strip(params[:keyword].to_s)}' and sort<>#{params[:sort]}"
    if wf.nil?
      @webpm = Webpm.find :first, :conditions=>["id=#{params[:id]}"]
      @webpm.keyword = strip(params[:keyword].to_s)
      @webpm.value = strip(params[:value].to_s)
      @webpm.sort = params[:sort]
      @webpm.description = params[:description1]
      @webpm.udate = Time.now
      if @webpm.save
        expire_webpm_memcache(params[:keyword])
        @forward_url = "/webpm/list?sort=#{params[:sort]}"
      end
    else
      @alert_text = "操作失败：不同的类别里不允许存在相同的关键字的参数!"
    end
    action_render   #@alert_text,@forward_url,@render_text
  end
  
  def del #删除记录
    return false unless pvalidate("删除参数记录","管理员")
    ids = []
    ids << params[:id].to_i if params[:id].to_i > 0
    ids = ids.concat(params[:ids].to_s.split(",").map{|e| e.to_i}) unless params[:ids].blank?
    if ids.length == 0
      @alert_text = "参数错误!"
    else
      begin
        webpms = Webpm.find(:all, :select=>"keyword", :conditions=>["id in (?)", ids])
        webpms.each do |webpm|
          expire_webpm_memcache(webpm.keyword)
        end
        Webpm.delete_all ["id in (?)", ids] if webpms.length >0
      rescue Exception => e
        @alert_text = e.to_s
      end
    end
    if @alert_text.blank?
      render :text => js(top_load("self"))
    else
      render :text => alert(@alert_text)
    end
  end
end
