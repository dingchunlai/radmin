class WenbaController < ApplicationController

  ## 已删除的主帖搜索结果
  def topics
    return false unless pvalidate("浏览问吧问题列表","管理员","问吧管理")
    @riqi1 = params[:riqi1]
    @riqi2 = params[:riqi2]
    @username = trim(params[:username])
    @keyword = params[:keyword]
    cd = "is_delete = 1"
    cd += " and subject like '%#{@keyword}%'" if pp(@keyword)
    cd += " and created_at >= '#{@riqi1} 0:0:0'" if pp(@riqi1)
    cd += " and created_at <= '#{@riqi2} 23:59:59'" if pp(@riqi2)
    if pp(@username)
      if @username.to_i==0
        hub = HejiaUserBbs.find_by_USERNAME(@username,:select=>"USERBBSID")
        user_id = hub.USERBBSID if hub
      else
        user_id = @username
      end
      cd += " and user_id = #{user_id}" if user_id
    end

    @recordcount = AskZhidaoTopic.count("id",:conditions => cd)

    h = Hash.new
    h["model"] = AskZhidaoTopic
    h["pagesize"] = 20 #每页记录数
    h["listsize"] = 10 #同时显示的页码数
    h["select"] = "id, subject, user_id, description, tag_id, post_counter, created_at"
    h["conditions"] = cd
    h["order"] = "created_at desc"
    @topics = paging_record(h)
  end


  ## 删除主帖恢复
  def recovery_all
    ids = params[:ids]
    unless ids.blank?
      AskZhidaoTopic.update_all("is_delete = 0", "id in (#{ids})")
    end
    redirect_to "/wenba/topics?&riqi1=#{params[:riqi1]}&riqi2=#{params[:riqi2]}&username=#{params[:username]}&keyword=#{params[:keyword]}"
  end


  def operations
    @riqi1 = params[:riqi1]
    @riqi2 = params[:riqi2]
    @wu_state = params[:wu_state]
    @username = trim(params[:username])
    @radmin_username = trim(params[:radmin_username])

    conditions = "true"
    unless @username.blank?
      if @username.to_i==0
        user_ids = HejiaUserBbs.find(:all,:conditions => ["USERNAME like ?","%#{@username}%"],:select=>"USERBBSID").map{|u|u.USERBBSID}
        conditions += " and user_id in (#{user_ids.join(',')})" unless user_ids.blank?
      else
        user_id = @username
        conditions += " and user_id = #{user_id}"
      end
    end
    conditions += " and state = '#{@wu_state}'" unless @wu_state.blank?
    conditions += " and updated_at >= '#{@riqi1} 0:0:0'" unless @riqi1.blank?
    conditions += " and updated_at <= '#{@riqi2} 23:59:59'" unless @riqi2.blank?
    unless @radmin_username.blank?
      if @radmin_username.to_i==0
        radmin_user_ids = HejiaStaff.find(:all,:conditions => ["name like ?","%#{@radmin_username}%"]).map{|u|u.id}
        conditions += " and user_id in (#{radmin_user_ids})" unless radmin_user_ids.blank?
      else
        conditions += "radmin_user_id = #{@radmin_username.to_i}"
      end
    end

    @recordcount = WenbaUser.count("id",:conditions => conditions)

    h = Hash.new
    h["model"] = WenbaUser
    h["pagesize"] = 20 #每页记录数
    h["listsize"] = 10 #同时显示的页码数
    h["select"] = "*"
    h["conditions"] = conditions
    h["order"] = "created_at desc"
    @wenba_users = paging_record(h)
  end

  ## 问吧用户批量操作
  def operation_all
    @wu_ids = params[:wu_ids]
    @state = params[:state]
    @reason = params[:reason]
    @freeze_time = params[:freeze_time]
    unless @wu_ids.blank?
      @wenba_users = WenbaUser.find(:all,:conditions => ["id in (#{@wu_ids})"])
      for wenba_user in @wenba_users
        wenba_user.state = @state
        wenba_user.reason = @reason
        wenba_user.freeze_time = @freeze_time
        wenba_user.radmin_user_id = session['user:staff:id']
        wenba_user.updated_at = Time.now.to_s(:db)

        ## 禁止访问
        if @state == "2"
          HejiaUserBbs.update_all("freeze_date = '#{@freeze_time}'", "USERBBSID = #{wenba_user.user_id}")
        elsif @state == "0"
          HejiaUserBbs.update_all("freeze_date = '#{Time.now.to_s(:db)}'", "USERBBSID = #{wenba_user.user_id}")
        end
        wenba_user.save
      end
    end

    redirect_to "/wenba/operations?&riqi1=#{params[:riqi1]}&riqi2=#{params[:riqi2]}&username=#{params[:username]}&radmin_username=#{params[:radmin_username]}&wu_state=#{params[:wu_state]}"
  end

  ## 问吧用户管理
  def users
    @username = params[:username]
    unless @username.blank?
      if @username
        if @username.to_i==0
          @hu = HejiaUserBbs.find_by_USERNAME(@username.strip)
        else
          @hu = HejiaUserBbs.find(@username)
        end
      end
      
      if @hu
        @wenba_user = WenbaUser.find_by_user_id(@hu.USERBBSID)
        if @wenba_user.blank?
          ## insert into wenba_users(user_id,name,regist_time,ip_address) SELECT USERBBSID,USERNAME,CREATTIME,LOGINIP FROM HEJIA_USER_BBS
          @wenba_user = WenbaUser.new(:user_id => @hu.USERBBSID,:ip_address => @hu.LOGINIP, :regist_time => @hu.CREATTIME, :name => @hu.USERNAME, :radmin_user_id => session['user:staff:id'])
        else
          if @wenba_user.freeze_time and @wenba_user.freeze_time < Time.now
            @wenba_user.state = "0"
            @wenba_user.save
          end
        end
      end
    end
  end

  ## 创建问吧用户管理
  def create_wenba_user
    @wenba_user = WenbaUser.find_by_user_id(params[:wenba_user][:user_id])
    if @wenba_user
      @wenba_user.update_attributes(params[:wenba_user])
    else
      @wenba_user = WenbaUser.create(params[:wenba_user])
      @wenba_user.created_at = Time.now.to_s(:db)
    end
    @wenba_user.updated_at = Time.now.to_s(:db)
    @wenba_user.radmin_user_id = session['user:staff:id']
    @wenba_user.save
    
    @hu = @wenba_user.user
    if @wenba_user.state == "2"
      @hu.freeze_date = @wenba_user.freeze_time
    elsif @wenba_user.state == "0"
      @hu.freeze_date = Time.now.to_s(:db)
    end
    @hu.save

    ## 删除主帖
    if params[:zhutie] == "1"
      AskZhidaoTopic.update_all("is_delete = 1","user_id = #{@wenba_user.user_id}")
    end

    ## 删除回帖
    if params[:huitie] == "1"
      AskZhidaoTopicPost.update_all("is_delete = 1","user_id = #{@wenba_user.user_id}")
    end
    
    redirect_to :action => "users", :username => @wenba_user.name
  end
  
  def get_hash_lv1_tags
    h = Hash.new
    h[1] = "家居"
    h[38] = "建材"
    h[173] = "装潢"
    h[265] = "社区服务"
    return h
  end

  def tags_to_js
    js_level_1 = "var class_level_1=new Array(@replace);"
    js_level_2 = "var class_level_2=new Array(@replace);"
    js_level_3 = "var class_level_3=new Array(@replace);"
    #level 1
    tags_level_1 = WenbaTag.find(:all,:select=>"id,name",:conditions=>"id in (#{get_hash_lv1_tags.keys.join(",")})")
    str_tags_level_1 = tags_level_1.collect{|c| "new Array(\"#{c.id}\",\"#{c.name}\")"}.join(',')
    #level 2
    if tags_level_1.size == 0
      str_tags_level_2 = ""
    else
      tags_level_2 = WenbaTag.find(:all,
        :conditions => "parent_id in (#{tags_level_1.collect{|c| c.id}.join(',')})")
      str_tags_level_2 = tags_level_2.collect{|c| "new Array(\"#{c.parent_id}\",\"#{c.id}\",\"#{c.name}\")"}.join(',')
    end
    #level 3
    if tags_level_2.size == 0
      str_tags_level_3 = ""
    else
      tags_level_3 = WenbaTag.find(:all,
        :conditions => "parent_id in (#{tags_level_2.collect{|c| c.id}.join(',')})")
      str_tags_level_3 = tags_level_3.collect{|c| "new Array(\"#{c.parent_id}\",\"#{c.id}\",\"#{c.name}\")"}.join(',')
    end
    #file operation
    js = js_level_1.gsub("@replace", str_tags_level_1) + "\n" +
      js_level_2.gsub("@replace", str_tags_level_2) + "\n" +
      js_level_3.gsub("@replace", str_tags_level_3)

    #js = "test"
    js_name = "public/javascripts/tagsjs"
    copy_js_name = "public/javascripts/tagsjs_#{Time.now.strftime("%Y%m%d%H%M%S")}.js"
    FileUtils.copy_file(js_name, copy_js_name) if File.exist?(js_name)
    open(js_name, "w") { |f| f.puts js }

    render :text => alert("操作成功：js文件已更新！")
  end

  def tag_manage
    @lv1_tags = get_hash_lv1_tags
    @lv1_tag_id = params[:lv1_tag_id].to_i
    @lv2_tag_id = params[:lv2_tag_id].to_i
    @lv3_tag_id = params[:lv3_tag_id].to_i
    @lv1_tag_id = 1 if @lv1_tag_id == 0
    flash[:lv1_tag_id] = @lv1_tag_id
    flash[:lv2_tag_id] = @lv2_tag_id
    @lv2_tags = WenbaTag.find(:all,:select=>"id,name,parent_id",:conditions=>["parent_id = ?", @lv1_tag_id])
    @lv3_tags = WenbaTag.find(:all,:select=>"id,name,parent_id",:conditions=>["parent_id = ?", @lv2_tag_id]) if @lv2_tag_id!=0
  end

  def tag_addnew_save(rv="",load_url=nil)
    tag_name = trim(params[:tag_name])
    parent_id = params[:parent_id].to_i
    rv = "操作失败：参数不足！" if !pp(tag_name) || parent_id==0
    rv = "操作失败：已存在相同的分类！" unless WenbaTag.find(:first,:select=>"id",:conditions=>["name=? and parent_id=?",tag_name,parent_id]).nil?
    if rv == ""
      begin
        WenbaTag.create(:name=>tag_name,:parent_id=>parent_id)
        load_url = "self"
      rescue Exception => e
        rv = alert_error("操作失败：#{get_error(e)}")
      end
    end
    myrender(rv, load_url)
  end

  def wenba_word_filter
    return false unless pvalidate("浏览过滤关键字列表","管理员","问吧管理")
    word_filter
    render :template => "/common/word_filter"
  end

  def topic_list
    return false unless pvalidate("浏览问吧问题列表","管理员","问吧管理")
    @riqi1 = params[:riqi1]
    @riqi2 = params[:riqi2]
    @keyword = trim(params[:keyword])
    @username = trim(params[:username])
    @method = params[:method].to_i
    cd = "is_delete = 0"
    cd += " and subject like '%%#{@keyword}%%'" if pp(@keyword)
    cd += " and created_at >= '#{@riqi1} 0:0:0'" if pp(@riqi1)
    cd += " and created_at <= '#{@riqi2} 23:59:59'" if pp(@riqi2)
    cd += " and method <> 1" if @method == 1 #真实数据
    cd += " and method = 1 and tag_id is null" if @method == 2
    cd += " and method = 1 and tag_id is not null" if @method == 3
    if pp(@username)
      if @username.to_i==0
        user_id = HejiaUserBbs.find_by_USERNAME(@username,:select=>"USERBBSID").USERBBSID
      else
        user_id = @username
      end
      cd += " and user_id = #{user_id}" unless user_id.blank?
    end
    @recordcount = 9999 if cd == "is_delete = 0" #如果查询的条件子句不限定条件，则不进行count查询，否则非常慢。
    h = Hash.new
    h["model"] = AskZhidaoTopic
    h["pagesize"] = 20 #每页记录数
    h["listsize"] = 10 #同时显示的页码数
    h["select"] = "id, subject, tag_id, post_counter, user_id, created_at"
    #h["primary_key"] = "USERBBSID"
    h["conditions"] = cd
    h["order"] = "created_at desc"
    @topics = paging_record(h)
  end

  def tag_assign(rv="", ru=nil)
    return false unless pvalidate("问吧问题分配栏目操作","管理员","问吧管理")
    topic_ids = params[:topic_ids].to_s
    tag_id = params[:tag_id].to_i
    yesternow = dateadd(Time.now,-1).strftime("%Y-%m-%d %H:%M:%S")
    if tag_id == 0 || trim(topic_ids).length == 0
      rv = "操作失败：参数错误！"
    else
      begin
        for tid in topic_ids.split(",")
          if tid.to_i > 0
            AskZhidaoTopicPost.update_all("created_at = '#{getnow()}'", "zhidao_topic_id = #{tid}")
            AskZhidaoTopic.update_all("tag_id = #{tag_id}, created_at = '#{yesternow}'", "id = #{tid}")
          end
        end
        for topic_id in topic_ids.split(",")
          kw_topic = "topic_#{topic_id}"
          WENBA_CACHE.set(kw_topic, nil)
          kw_posts = "posts_#{topic_id}"
          WENBA_CACHE.set(kw_posts, nil)
        end
        #rv = "操作成功：问题已分配。"
      rescue Exception => e
        rv = "操作失败：#{get_error(e)}"
      end
    end
    myrender(rv,ru)
  end

  def topic_del
    return false unless pvalidate("删除问题","管理员","问吧管理")
    topic_ids = params[:ids].to_s
    AskZhidaoTopic.update_all("is_delete = 1", "id in (#{topic_ids})")
    redirect_to :back
  end

  ## 批量删除用户和主帖
  def users_del
    return false unless pvalidate("删除问题","管理员","问吧管理")
    topic_ids = params[:ids].to_s
    @reason = params[:reason]

    @model = HejiaUserBbs
    @sql = "select hub.* "
    @sql += "from HEJIA_USER_BBS as hub inner join ask_zhidao_topics as azt on hub.USERBBSID = azt.user_id where "
    @sql += "azt.id in (#{topic_ids}) order by hub.USERBBSID desc"

    @members = HejiaUserBbs.find_by_sql(@sql)
    @members = @members.uniq

    for hub in @members
      tmp_wenba_user = WenbaUser.find_by_user_id(hub.USERBBSID)
      wenba_user = tmp_wenba_user.blank? ? WenbaUser.new(:user_id => hub.USERBBSID, :name => hub.USERNAME) : tmp_wenba_user

      wenba_user.state = 1
      wenba_user.reason = @reason
      wenba_user.freeze_time = 25.year.from_now.to_s(:db)
      wenba_user.radmin_user_id = session['user:staff:id']
      wenba_user.updated_at = Time.now.to_s(:db)

      ## 禁止访问
      hub.freeze_date = 25.year.from_now.to_s(:db)
      hub.save
      wenba_user.save
    end

    user_ids = @members.map{|m|m.USERBBSID}.join(",")
    ## 删除主帖
    AskZhidaoTopic.update_all("is_delete = 1","user_id in (#{user_ids})")

    ## 删除回帖
    AskZhidaoTopicPost.update_all("is_delete = 1","user_id in (#{user_ids})")

    redirect_to :back
  end

  def delete_user
    hub = HejiaUserBbs.find_by_USERBBSID(params[:uid])

    tmp_wenba_user = WenbaUser.find_by_user_id(hub.USERBBSID)
    wenba_user = tmp_wenba_user.blank? ? WenbaUser.new(:user_id => hub.USERBBSID, :name => hub.USERNAME) : tmp_wenba_user

    wenba_user.state = 1
    wenba_user.reason = "发布不良信息"
    wenba_user.freeze_time = 25.year.from_now.to_s(:db)
    wenba_user.radmin_user_id = session['user:staff:id']
    wenba_user.updated_at = Time.now.to_s(:db)

    ## 禁止访问
    hub.freeze_date = 25.year.from_now.to_s(:db)
    hub.save
    wenba_user.save

    ## 删除主帖
    AskZhidaoTopic.update_all("is_delete = 1","user_id = #{params[:uid]}")

    ## 删除回帖
    AskZhidaoTopicPost.update_all("is_delete = 1","user_id = #{params[:uid]}")
    redirect_to :back
  end

  def focus_topic
    return false unless pvalidate("焦点问题维护","管理员","问吧管理")
    cd = "sort_id = 1"
    h = Hash.new
    h["model"] = Url
    h["pagesize"] = 12 #每页记录数
    h["listsize"] = 10 #同时显示的页码数
    h["select"] = "id, title, url, created_at, updated_at"
    #h["primary_key"] = "USERBBSID"
    h["conditions"] = cd
    h["order"] = "updated_at desc"
    @ftopics = paging_record(h)
  end

  def focus_topic_save(rv="",load_url=nil)
    return false unless pvalidate("焦点问题保存","管理员","问吧管理")
    rv = "操作失败：请填写标题！" unless pp(params[:title])
    rv = "操作失败：请填写链接！" unless pp(params[:url])
    if rv == ""
      begin
        Url.create(:sort_id=>1,:title=>params[:title],:url=>params[:url])
        rv = "操作成功：数据添加成功！"
        load_url = "self"
      rescue Exception => e
        rv = "操作失败：#{get_error(e)}"
      end
    end
    myrender(rv, load_url)
  end

  def focus_topic_del(rv="",load_url=nil)
    return false unless pvalidate("焦点问题删除","管理员","问吧管理")
    if rv == ""
      begin
        Url.delete_all("id in (#{params[:ids]}) and sort_id = 1")
        load_url = "self"
      rescue Exception => e
        rv = "操作失败：#{get_error(e)}"
      end
    end
    myrender(rv, load_url)
  end

  def focus_topic_set_updated(rv="",load_url=nil)
    return false unless pvalidate("焦点问题设为最新","管理员","问吧管理")
    if rv == ""
      begin
        Url.update_all("updated_at = now()", "id = #{params[:id]} and sort_id = 1")
        load_url = "self"
      rescue Exception => e
        rv = "操作失败：#{get_error(e)}"
      end
    end
    myrender(rv, load_url)
  end

  def focus_topic
    return false unless pvalidate("焦点问题维护","管理员","问吧管理")
    cd = "sort_id = 1"
    h = Hash.new
    h["model"] = Url
    h["pagesize"] = 12 #每页记录数
    h["listsize"] = 10 #同时显示的页码数
    h["select"] = "id, title, url, created_at, updated_at"
    #h["primary_key"] = "USERBBSID"
    h["conditions"] = cd
    h["order"] = "updated_at desc"
    @ftopics = paging_record(h)
  end

  def focus_topic_save(rv="",load_url=nil)
    return false unless pvalidate("焦点问题保存","管理员","问吧管理")
    rv = "操作失败：请填写标题！" unless pp(params[:title])
    rv = "操作失败：请填写链接！" unless pp(params[:url])
    if rv == ""
      begin
        Url.create(:sort_id=>1,:title=>params[:title],:url=>params[:url])
        rv = "操作成功：数据添加成功！"
        load_url = "self"
      rescue Exception => e
        rv = "操作失败：#{get_error(e)}"
      end
    end
    myrender(rv, load_url)
  end

  def focus_topic_del(rv="",load_url=nil)
    return false unless pvalidate("焦点问题删除","管理员","问吧管理")
    if rv == ""
      begin
        Url.delete_all("id in (#{params[:ids]}) and sort_id = 1")
        load_url = "self"
      rescue Exception => e
        rv = "操作失败：#{get_error(e)}"
      end
    end
    myrender(rv, load_url)
  end

  def focus_topic_set_updated(rv="",load_url=nil)
    return false unless pvalidate("焦点问题设为最新","管理员","问吧管理")
    if rv == ""
      begin
        Url.update_all("updated_at = now()", "id = #{params[:id]} and sort_id = 1")
        load_url = "self"
      rescue Exception => e
        rv = "操作失败：#{get_error(e)}"
      end
    end
    myrender(rv, load_url)
  end

  def notice_list
    return false unless pvalidate("问吧公告栏列表","管理员","问吧管理")
    cd = "sort_id = 2"
    h = Hash.new
    h["model"] = Url
    h["pagesize"] = 12 #每页记录数
    h["listsize"] = 10 #同时显示的页码数
    h["select"] = "id, title, url, created_at, updated_at"
    #h["primary_key"] = "USERBBSID"
    h["conditions"] = cd
    h["order"] = "updated_at desc"
    @ftopics = paging_record(h)
  end

  def notice_save(rv="",load_url=nil)
    return false unless pvalidate("问吧公告栏条目保存","管理员","问吧管理")
    rv = "操作失败：请填写标题！" unless pp(params[:title])
    rv = "操作失败：请填写链接！" unless pp(params[:url])
    if rv == ""
      begin
        Url.create(:sort_id=>2,:title=>params[:title],:url=>params[:url])
        rv = "操作成功：数据添加成功！"
        load_url = "self"
      rescue Exception => e
        rv = "操作失败：#{get_error(e)}"
      end
    end
    myrender(rv, load_url)
  end

  def notice_del(rv="",load_url=nil)
    return false unless pvalidate("问吧公告栏条目删除","管理员","问吧管理")
    if rv == ""
      begin
        Url.delete_all("id in (#{params[:ids]}) and sort_id = 2")
        load_url = "self"
      rescue Exception => e
        rv = "操作失败：#{get_error(e)}"
      end
    end
    myrender(rv, load_url)
  end

  def notice_set_updated(rv="",load_url=nil)
    return false unless pvalidate("问吧公告栏条目设为最新","管理员","问吧管理")
    if rv == ""
      begin
        Url.update_all("updated_at = now()", "id = #{params[:id]} and sort_id = 2")
        load_url = "self"
      rescue Exception => e
        rv = "操作失败：#{get_error(e)}"
      end
    end
    myrender(rv, load_url)
  end

  ## 搜索区间问吧问题
  def section_topics
    return false unless pvalidate("浏览问吧问题列表","管理员","问吧管理")
    @start_id = params[:start_id].to_i
    @end_id = params[:end_id].to_i
    cd = "is_delete = 0"
    cd += " and id >= #{@start_id}" if pp(@start_id)
    cd += " and id <= #{@end_id}" if pp(@end_id)
    @recordcount = 9999 if cd == "is_delete = 0" #如果查询的条件子句不限定条件，则不进行count查询，否则非常慢。
    h = Hash.new
    h["model"] = AskZhidaoTopic
    h["pagesize"] = 50 #每页记录数
    h["listsize"] = 10 #同时显示的页码数
    h["select"] = "id, subject, tag_id, post_counter, user_id, created_at"
    #h["primary_key"] = "USERBBSID"
    h["conditions"] = cd
    h["order"] = "created_at desc"
    @topics = paging_record(h)
  end

  ## 删除区间问吧问题
  def section_topics_del
    return false unless pvalidate("删除问题","管理员","问吧管理")

    conditions = ""

    if params[:start_id].to_i.to_s == params[:start_id] and params[:end_id].to_i.to_s == params[:end_id]
      conditions = "id >= #{params[:start_id].to_i} and id <= #{params[:end_id].to_i}"
    end
    AskZhidaoTopic.update_all("is_delete = 1",conditions) unless conditions.blank?

    redirect_to :action => "section_topics", :start_id => params[:start_id], :end_id => params[:end_id]
  end

  def manage_users
    @curpage = params["curpage"].blank? ? 1 : params["curpage"].to_i
    @per_page = params["per_page"].blank? ? 100 : params["per_page"].to_i
    @username = params[:username]

    @model = HejiaUserBbs
    @sql = "select hub.USERBBSID, hub.USERNAME, hub.USERBBSEMAIL, hub.AREA, hub.CITY, hub.USERTYPE, hub.USERBBSTEL, hub.CREATTIME, hub.LOGINDATE, hub.ask_expert,hub.USERBBSSEX, hub.MSN, hub.QQ, hub.deco_id, hub.class_name "

    @conditions = "(hub.freeze_date is null or hub.freeze_date < '#{Time.now.to_s(:db)}')"
    unless @username.blank?
      @conditions += " and hub.USERNAME like '%#{@username}%'"
      @sql += " from 51hejia.HEJIA_USER_BBS hub where #{@conditions} order by USERBBSID DESC"
    else
      @conditions += " and false"
      @sql += " from 51hejia.HEJIA_USER_BBS hub where #{@conditions} order by USERBBSID DESC"
    end

    @tmp_members = HejiaUserBbs.find_by_sql(@sql)
    @members = @tmp_members.map{|m|m if m.wenba_topics.count > 0}
    @members = @members.compact
    @total_entries = @members.size
    @members = @members.paginate(:page => @curpage, :per_page => @per_page)
    @total_page = (@total_entries.to_f / @per_page.to_f).ceil
  end

  def manage_users_del
    @wu_ids = params[:wu_ids]
    @reason = params[:reason]
    unless @wu_ids.blank?
      for uid in @wu_ids.split(",")
        hub = HejiaUserBbs.find_by_USERBBSID(uid.to_i)
        unless hub.blank?
          tmp_wenba_user = WenbaUser.find_by_user_id(uid.to_i)
          wenba_user = tmp_wenba_user.blank? ? WenbaUser.new(:user_id => uid, :name => hub.USERNAME) : tmp_wenba_user

          wenba_user.state = 1
          wenba_user.reason = @reason
          wenba_user.freeze_time = 25.year.from_now.to_s(:db)
          wenba_user.radmin_user_id = session['user:staff:id']
          wenba_user.updated_at = Time.now.to_s(:db)

          ## 禁止访问
          hub.freeze_date = 25.year.from_now.to_s(:db)
          hub.save
          wenba_user.save
        end
      end

      ## 删除主帖
      AskZhidaoTopic.update_all("is_delete = 1","user_id in (#{@wu_ids})")

      ## 删除回帖
      AskZhidaoTopicPost.update_all("is_delete = 1","user_id in (#{@wu_ids})")

    end

    redirect_to :action => "manage_users", :username => params[:username], :per_page => params[:per_page], :curpage => params[:curpage]

  end

  def wenba_users
    @curpage = params["curpage"].blank? ? 1 : params["curpage"].to_i
    @per_page = params["per_page"].blank? ? 100 : params["per_page"].to_i
    @username = params[:username]

    @model = HejiaUserBbs
    @sql = "select count(hub.USERBBSID),hub.USERBBSID, hub.USERNAME, hub.USERBBSEMAIL, hub.AREA, hub.CITY,hub.USERBBSSEX, hub.ask_expert "
    @sql += "from HEJIA_USER_BBS as hub inner join ask_zhidao_topics as azt on hub.USERBBSID = azt.user_id where "
    @sql += "(hub.freeze_date is null or hub.freeze_date < '#{Time.now.to_s(:db)}') and CREATTIME > '#{1.month.ago.to_s(:db)}' "
    @sql += "and azt.is_delete = 0 group by hub.USERBBSID order by count(hub.USERBBSID) desc"

    @members = HejiaUserBbs.find_by_sql(@sql)
    @total_entries = @members.size
    @members = @members.paginate(:page => @curpage, :per_page => @per_page)
    @total_page = (@total_entries.to_f / @per_page.to_f).ceil
  end

  def wenba_users_del
    @wu_ids = params[:wu_ids]
    @reason = params[:reason]
    unless @wu_ids.blank?
      for uid in @wu_ids.split(",")
        hub = HejiaUserBbs.find_by_USERBBSID(uid.to_i)
        unless hub.blank?
          tmp_wenba_user = WenbaUser.find_by_user_id(uid.to_i)
          wenba_user = tmp_wenba_user.blank? ? WenbaUser.new(:user_id => uid, :name => hub.USERNAME) : tmp_wenba_user

          wenba_user.state = 1
          wenba_user.reason = @reason
          wenba_user.freeze_time = 25.year.from_now.to_s(:db)
          wenba_user.radmin_user_id = session['user:staff:id']
          wenba_user.updated_at = Time.now.to_s(:db)

          ## 禁止访问
          hub.freeze_date = 25.year.from_now.to_s(:db)
          hub.save
          wenba_user.save
        end
      end

      ## 删除主帖
      AskZhidaoTopic.update_all("is_delete = 1","user_id in (#{@wu_ids})")

      ## 删除回帖
      AskZhidaoTopicPost.update_all("is_delete = 1","user_id in (#{@wu_ids})")

    end

    redirect_to :action => "wenba_users", :per_page => params[:per_page], :curpage => params[:curpage]

  end


  ## 问题帖子审核
  def examine_topics
    return false unless pvalidate("浏览问吧问题列表","管理员","问吧管理")
    @riqi1 = params[:riqi1]
    @riqi2 = params[:riqi2]
    @keyword = trim(params[:keyword])
    @username = trim(params[:username])
    @method = params[:method].to_i
    cd = "is_delete = -1"
    cd += " and subject like '%%#{@keyword}%%'" if pp(@keyword)
    cd += " and created_at >= '#{@riqi1} 0:0:0'" if pp(@riqi1)
    cd += " and created_at <= '#{@riqi2} 23:59:59'" if pp(@riqi2)
    cd += " and method <> 1" if @method == 1 #真实数据
    cd += " and method = 1 and tag_id is null" if @method == 2
    cd += " and method = 1 and tag_id is not null" if @method == 3
    if pp(@username)
      if @username.to_i==0
        user_id = HejiaUserBbs.find_by_USERNAME(@username,:select=>"USERBBSID").USERBBSID
      else
        user_id = @username
      end
      cd += " and user_id = #{user_id}" unless user_id.blank?
    end
    @recordcount = 9999 if cd == "is_delete = 0" #如果查询的条件子句不限定条件，则不进行count查询，否则非常慢。
    h = Hash.new
    h["model"] = AskZhidaoTopic
    h["pagesize"] = 20 #每页记录数
    h["listsize"] = 10 #同时显示的页码数
    h["select"] = "id, subject,description, tag_id, post_counter, user_id, created_at"
    #h["primary_key"] = "USERBBSID"
    h["conditions"] = cd
    h["order"] = "created_at desc"
    @topics = paging_record(h)
  end

  ## 审核通过
  def examine
    return false unless pvalidate("删除问题","管理员","问吧管理")
    topic_ids = params[:ids].to_s
    AskZhidaoTopic.update_all("is_delete = 0", "id in (#{topic_ids})")
    redirect_to :back
  end

  ## 问吧发贴时间设置
  def time_mechanisms
    @time_mechanism = TimeMechanism.find(:first)
    if @time_mechanism.blank?
      @time_mechanism = TimeMechanism.new()
    end
  end

  def tm_save
    @time_mechanism = TimeMechanism.find(:first)
    if @time_mechanism.blank?
      @time_mechanism = TimeMechanism.new(params[:time_mechanism])
      @time_mechanism.save
    else
      @time_mechanism.update_attributes(params[:time_mechanism])
    end
    redirect_to :action => "time_mechanisms"
  end

  def posts
    return false unless pvalidate("浏览问吧问题列表","管理员","问吧管理")
    @keyword = trim(params[:keyword])
    cd = "is_delete = 0"
    cd += " and content like '%#{@keyword}%'" if pp(@keyword)
    h = Hash.new
    h["model"] = AskZhidaoTopicPost
    h["pagesize"] = 50 #每页记录数
    h["listsize"] = 10 #同时显示的页码数
    h["select"] = "id, zhidao_topic_id, content, created_at"
    h["conditions"] = cd
    h["order"] = "created_at desc"
    @posts = paging_record(h)
  end

  ## 问题帖子审核
  def examine_posts
    return false unless pvalidate("浏览问吧问题列表","管理员","问吧管理")
    @keyword = trim(params[:keyword])
    cd = "is_delete = -1"
    cd += " and content like '%#{@keyword}%'" if pp(@keyword)
    h = Hash.new
    h["model"] = AskZhidaoTopicPost
    h["pagesize"] = 50 #每页记录数
    h["listsize"] = 10 #同时显示的页码数
    h["select"] = "id, zhidao_topic_id, content, created_at"
    h["conditions"] = cd
    h["order"] = "created_at desc"
    @posts = paging_record(h)
  end

  ## 审核通过
  def posts_examine
    return false unless pvalidate("删除问题","管理员","问吧管理")
    post_ids = params[:ids].to_s
    AskZhidaoTopicPost.update_all("is_delete = 0", "id in (#{post_ids})")
    redirect_to :back
  end

  def posts_del
    return false unless pvalidate("删除问题","管理员","问吧管理")
    post_ids = params[:ids].to_s
    AskZhidaoTopicPost.update_all("is_delete = 1", "id in (#{post_ids})")
    redirect_to :back
  end

end
