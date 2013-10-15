class HejiatagController < ApplicationController
  before_filter :user_validate, :except => :login #验证用户身份 

  def inner_link_list
    @stext = trim(params[:stext])
    conditions = []
    conditions << "keyword like '%#{@stext}%'" if @stext.length > 0
    @rs = paging_record options = {
        "model" => InnerLink,
        "pagesize" => 2,   #每页记录数
        "listsize" => 10,  #同时显示的页码数
        "select" => "id, keyword, url, created_at",
        "conditions" => conditions.join(" and "),
        "order" => "id desc"
    }
  end

  def inner_link_save(rv="",ru=nil)
    keyword = params[:keyword].to_s
    kw_url = params[:kw_url].to_s.gsub("http://","")
    rv = "请正确填写关键词及链接！" if keyword.length<2 || kw_url.length <2
    if rv == ""
      begin
        InnerLink.create({:keyword=>keyword,:url=>kw_url})
        ru = "reload"
      rescue Exception => e
        if e.to_s.include?("Duplicate")
          rv = "已存在重复的记录！"
        else
          rv = get_error(e)
        end
      end
    end
    myrender(rv, ru)
  end

  def inner_link_del(rv="",ru=nil)
     ids = params[:ids].to_s
     rv = "参数错误！" if ids.length == 0
     if rv == ""
       begin
         InnerLink.delete_all("id in (#{ids})")
       rescue Exception => e
         rv = get_error(e)
       end
     end
     myrender(rv, ru)
  end

  def execute_has_child
    hts = HejiaTag.find :all, :select => "id"
    for ht in hts
      dosql("update hejia_tags set has_child = (select count(*) as c from hejia_tags_copy where parent_id = #{ht.id}) where id = #{ht.id}")
    end
    render :text => "ok"
  end
  
  def hejiatag_list2
    return false unless pvalidate("浏览关键字列表")
    per_page_num = 15   #每页记录数
    
    @parent_name = "根目录"
    @parent_id = 0
    @level = 1
    
    if pp(params[:parent_name])
      if params[:parent_name] != "根目录"
        ht = HejiaTag.find :first, :conditions => "name = '#{params[:parent_name]}' and flag = 2"
        @parent_name = ht.name
        @parent_id = ht.id
        @level = ht.level + 1
      end
    end
    if pp(params[:parent_id])
      if params[:parent_id]!="0"
        ht = HejiaTag.find(params[:parent_id])
        @parent_id = ht.parent_id
        if @parent_id.to_i != 0
          ht = HejiaTag.find(@parent_id)
          @parent_name = ht.name
          @level = ht.level + 1
        end
      end
    end
    
    str_conditions = "flag = 2"
    str_conditions += " and parent_id = #{@parent_id}"
    @hejiatag_pages, @hejiatags = paginate(:hejia_tags,
      :select => "id, name, parent_id, flag, level, has_child, initial, created_at, updated_at",
      :conditions => [str_conditions],
      :order => "id desc",
      :per_page => per_page_num)
  end
  
  def hejiatag_list
    return false unless pvalidate("浏览关键字列表")
    per_page_num = 15   #每页记录数
    
    @parent_name = "根目录"
    @parent_id = 0
    @level = 1
    
    if pp(params[:parent_name])
      if params[:parent_name] != "根目录"
        ht = HejiaTag.find :first, :conditions => "name = '#{params[:parent_name]}' and flag = 1"
        @parent_name = ht.name
        @parent_id = ht.id
        @level = ht.level + 1
      end
    end
    if pp(params[:parent_id])
      if params[:parent_id]!="0"
        ht = HejiaTag.find(params[:parent_id])
        @parent_id = ht.parent_id
        if @parent_id.to_i != 0
          ht = HejiaTag.find(@parent_id)
          @parent_name = ht.name
          @level = ht.level + 1
        end
      end
    end
    
    str_conditions = "flag = 1"
    str_conditions += " and parent_id = #{@parent_id}"
    @hejiatag_pages, @hejiatags = paginate(:hejia_tags,
      :select => "id, name, parent_id, flag, level, has_child, initial, created_at, updated_at",
      :conditions => [str_conditions],
      :order => "id desc",
      :per_page => per_page_num)
  end
  
  def hejiatag_del #删除记录
    return false unless pvalidate("删除关键字","管理员")
    begin
      HejiaTag.delete(params[:id]) if pp(params[:id])
      HejiaTag.delete_all "id in (#{params[:ids]})" if pp(params[:ids])
      render :text => js(top_load("self"))
    rescue Exception => e
      render :text => alert_error(get_error(e))
    end
  end
  
  def hejiatag_new
    return false unless pvalidate("添加关键字","管理员","关键字管理")
  end
  
  def hejiatag_new_save
    return false unless pvalidate("保存添加关键字","管理员","关键字管理")
    ht = HejiaTag.find_by_name(strip(params[:name]))
    if ht.nil?
     begin
          hejiatag = HejiaTag.new
          hejiatag.name = strip(params[:name])
          hejiatag.level = strip(params[:level])
          hejiatag.parent_id = strip(params[:parent_id])
          hejiatag.flag = 1
          hejiatag.initial = strip(params[:initial])
          hejiatag.created_at = Time.now
          hejiatag.updated_at = Time.now
          hejiatag.save
          render :text => alert("记录添加成功!") + js(top_load("/hejiatag/hejiatag_edit?id=#{hejiatag.id}"))
      rescue Exception => e
          render :text => alert_error(get_error(e))
      end
    else
      render :text => alert_error("操作失败：关键字 #{strip(params[:name])} 已经存在，不能重复添加相同的关键字")
    end
  end
  
  def hejiatag_create_save
    return false unless pvalidate("批量添加关键字","管理员","关键字管理")
    names = replace(params[:names],"　"," ").split(" ")
    exist_names = ""
    for name in names
          name = trim(name)
          ht = HejiaTag.find :first, :select => "id", :conditions => "name = '#{name}'and flag = #{params[:flag]}"
          if ht.nil?
              begin
              hejiatag = HejiaTag.new
              hejiatag.name = name
              hejiatag.level = params[:level]
              hejiatag.parent_id = params[:parent_id]
              hejiatag.flag = params[:flag]
              hejiatag.created_at = Time.now
              hejiatag.updated_at = Time.now
              hejiatag.save
              rescue Exception => e
                render :text => alert_error(get_error(e))
              end
          else
              exist_names += (name + ",")
          end
    end
    if exist_names == ""
      render :text => js(top_load("self"))
    else
      render :text => alert("添加操作完成，以下关键字因为已经存在，所以无法添加：#{exist_names}")
    end
  end
  
  def hejiatag_edit
    return false unless pvalidate("编辑关键字","管理员","关键字管理")
    begin
      @hejiatag = HejiaTag.find(params[:id])
    rescue Exception => e
          show_notice(get_error(e))
    end
  end
  
  def hejiatag_edit_save
    return false unless pvalidate("保存编辑关键字","管理员","关键字管理")
    ht = HejiaTag.find :first, :select => "id", :conditions => "name = '#{strip(params[:name])}' and id <> #{params[:id]}"
    if ht.nil?
        begin
        hejiatag = HejiaTag.find(params[:id])
        hejiatag.name = strip(params[:name])
        hejiatag.level = strip(params[:level])
        hejiatag.parent_id = strip(params[:parent_id])
        #hejiatag.flag = strip(params[:flag])
        hejiatag.initial = strip(params[:initial])
        hejiatag.updated_at = Time.now
            hejiatag.save
            render :text => alert("更新操作成功!")
        rescue Exception => e
            render :text => alert_error(get_error(e))
        end
    else
      render :text => alert_error("操作失败：关键字 #{strip(params[:name])} 已经存在，不能使用该关键字")
    end
  end
  
  def get_initial
    if pp(params[:id]) && pp(params[:initial])
      ht = HejiaTag.find(params[:id])
      ht.initial = trim(params[:initial])
      ht.save
    end
    ht = HejiaTag.find :first, :select => "id, name", :conditions => "initial is null"
    if ht.nil?
        render :text => alert("关键字首字母已全部完善!") + js(top_load("/"))
    else
        @cur_id = ht.id
        @cur_name = ht.name      
    end
    
  end
  
end
