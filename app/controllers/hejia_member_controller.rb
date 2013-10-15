class HejiaMemberController < ApplicationController

  def detail
    user_id = params[:user_id].to_i
    if user_id == 0
    else
      @member = HejiaUserBbs.find(user_id)
      @bbs_topics_count = AskForumTopic.find_by_sql("select count(id) from 51hejia_forum.bbs_topics where is_delete = 0 and user_id = #{user_id}")[0]["count(id)"].to_i
      @bbs_posts_count = AskForumTopicPost.find_by_sql("select count(p.id) from 51hejia_forum.ask_forum_topic_posts p, 51hejia_forum.bbs_topics t where p.is_delete = 0 and p.user_id = #{user_id} and p.forum_topic_id = t.id")[0]["count(p.id)"].to_i
      @wenba_topics_count = AskZhidaoTopic.count(:conditions => ["is_delete = 0 and user_id = ?", user_id])
      @wenba_posts_count = AskZhidaoTopicPost.count(:conditions => ["is_delete = 0 and user_id = ?", user_id])
    end
    render :layout => false
  end

  ## add by dingchunlai on 2011-9-6
  ## 用户bbs后台列表页
  ## params[:bbs_type]为空时显示bbs发帖，否则显示bbs回复帖
  def bbs_detail
    user_id = params[:user_id].to_i

    @member = HejiaUserBbs.find(user_id)

    @curpage = 1
    @bbs_type = params[:bbs_type]

    if @bbs_type.blank?
      @curpage = params[:page] if params[:page]

      @sql = "select id, subject, description, user_id, created_at from 51hejia_forum.bbs_topics"
      @sql += " where is_delete = 0 and user_id = #{user_id} order by id desc"
      @topics = AskForumTopic.find_by_sql(@sql)
      @topics = @topics.paginate(:page => @curpage, :per_page => 20)
    else
      @curpage = params[:p_page] if params[:p_page]

      @sql = "select p.id, p.user_id, p.forum_topic_id, p.content, p.created_at, t.subject from 51hejia_forum.ask_forum_topic_posts p, 51hejia_forum.bbs_topics t"
      @sql += " where p.is_delete = 0 and p.user_id = #{user_id} and p.forum_topic_id = t.id order by p.id desc limit #{@curpage - 1}, 20"
      @posts = AskForumTopicPost.find_by_sql(@sql)
      @posts = @posts.paginate(:page => @curpage, :per_page => 20)
    end
    render :layout => false
  end

  ## add by dingchunlai on 2011-9-6
  ## 用户问吧后台列表页
  def wenba_detail
    user_id = params[:user_id].to_i
    @member = HejiaUserBbs.find(user_id)
    @curpage = 1

    @wenba_type = params[:wenba_type]

    if @wenba_type.blank?
      @curpage = params[:page] if params[:page]

      @topics = AskZhidaoTopic.paginate(
        :select => "id, subject, description, created_at",
        :conditions => "is_delete = 0 and user_id = #{user_id}",
        :order => "id desc",
        :page => @curpage.to_i,
        :per_page => 20
      )
    else
      @curpage = params[:p_page] if params[:p_page]

      @posts = AskZhidaoTopicPost.paginate(
        :select => "id,content,zhidao_topic_id,created_at",
        :conditions => "is_delete = 0 and user_id = #{user_id}",
        :order => "id desc",
        :page => @curpage.to_i,
        :per_page => 20
      )
    end
    render :layout => false
  end


  def edit_user_email
    return false unless pvalidate("修改用户邮箱地址","管理员")
    unless params[:user_id]
      redirect_to :controller => 'hejia_member',:action =>'list'
      return
    end
    if request.post? && params[:user_id] && params[:user_email]
      if HejiaUserBbs.find(:first,:conditions =>["USERBBSEMAIL = ? and USERBBSID != ?",params[:user_email],params[:user_id]])
        flash[:flash_msg] = '对不起,你要修改的邮箱,数据库里已经存在。请更换其他的.'
        redirect_to :back
        return
      end
      @edited_user = HejiaUserBbs.find(params[:user_id].to_i)
      if @edited_user
        if @edited_user.update_attribute('USERBBSEMAIL',params[:user_email])
          flash[:flash_msg] = '修改邮箱成功'
          redirect_to :back
        end
      end
    else
      user_id = params[:user_id].to_i
      if user_id == 0
      else
        @edit_user = HejiaUserBbs.find(user_id,:select =>'USERBBSID,USERNAME,USERBBSSEX,USERBBSEMAIL')
        render :layout =>false
      end
    end
  end
  
  def set_supervisor
    @user = HejiaUserBbs.find(params[:id])
    @user.update_attribute(:class_name, "Supervisor")
    render :text => "#{@user.USERNAME}已被设置为监理员"
  end
  
  def cancel_supervisor
    @user = HejiaUserBbs.find(params[:id])
    @user.update_attribute(:class_name , "")
    render :text => "#{@user.USERNAME}已取消监理员"
  end

  def list
    @current_page = params["current_page"].blank? ? 1 : params["current_page"].to_i
    @per_page = params["per_page"].blank? ? 100 : params["per_page"].to_i
    get_conditions

    @members = HejiaUserBbs.find_by_sql(@sql)

    if params[:bbs_topic_count].blank? and params[:wenba_topic_count].blank?
      @total_entries = @model.find_by_sql(@count_sql)[0].total_hubs.to_i
    else
      @total_entries = @model.find_by_sql(@count_sql).size
    end
    @total_page = (@total_entries.to_f / @per_page.to_f).ceil
  end

  ## 将members导出为Excel表格存储的数据
  def export_members
    @current_page = params["current_page"].blank? ? 1 : params["current_page"].to_i
    @per_page = params["per_page"].blank? ? 100 : params["per_page"].to_i
    get_conditions

    @members = HejiaUserBbs.find_by_sql(@sql)

    e = Excel::Workbook.new
    sheetname = "用户列表"
    unless @members
      flash[:notice] = "没有符合条件的用户！"
      redirect_to "/common/export"
    else
      array = Array.new
      @members.each do |member|
        item = Hash.new
        #item["编号"] = member.id
        item["用户名"] = member.USERNAME
        item["EMAIL"] = member.USERBBSEMAIL
        #item["性别"] = member.USERBBSSEX
        item["地区"] = Tag.get_tagname_by_tagid(member.AREA)
        item["城市"] = Tag.get_tagname_by_tagid(member.CITY)
        item["电话"] = member.USERBBSTEL
        item["MSN/QQ"] = member.MSN.nil? ? member.QQ : member.MSN
        item["注册时间"] = member.CREATTIME
        item["最后登录时间"] = member.LOGINDATE.blank? ? "" : member.LOGINDATE
        #item["会员积分"] = member.POINT.nil? ? 0 : member.POINT
        #item["问吧专家"] = (member.ask_expert.to_i < 0) ? "申请中" : ((member.ask_expert.to_i == 0) ? "普通会员" : "#{member.tag.name}专家")
        #item["会员类型"] = (member.USERTYPE.to_i == 100) ? "专家" : ((member.USERTYPE.to_i == 200) ? "马甲名" : "普通会员")
        array << item
      end
      e.addWorksheetFromArrayOfHashes(sheetname, array)
      headers['Content-Type'] = "application/vnd.ms-excel;charset=GBK"
      headers['Content-Disposition'] = "attachment; filename=用户列表.xls"
      headers['Cache-Control'] = ''
      render :text => e.build
    end
  end

  #会员认证
  def member_check
    ids = params[:ids]
    num = params[:num]
    HejiaUserBbs.update_all("ischeck=#{num}","USERBBSID in (#{ids})")
    
    render :text => "操作成功"
  end

  def set_deco_id(rv="",load_url=nil)
    return false unless pvalidate("会员关联装修公司","管理员","会员管理")
    user_id = trim(params[:user_id])
    deco_id = trim(params[:deco_id])
    rv = "参数不足！" if !pp(user_id) || !pp(deco_id)
    begin
      HejiaUserBbs.update_all("deco_id = #{deco_id}", "USERBBSID = #{user_id}")
      load_url = "self"
    rescue Exception => e
      rv = "操作失败：#{get_error(e)}"
    end
    rv = alert(rv) unless rv == ""
    rv += js(top_load(load_url)) unless load_url == nil
    render :text => rv
  end

  def expert_set_save
    user_id = params[:user_id].to_i
    settype = params[:settype].to_i
    return false if user_id == 0 || settype == 0
    user = HejiaUserBbs.find(user_id,:select=>"USERBBSID, USERNAME, ask_expert")
    
    if settype == 1
      ask_expert = -user.ask_expert
      user.ask_expert = ask_expert
      user.save
      CommunityUser.update_all("ask_expert=#{ask_expert}", "user_id = #{user_id}")
      #update community_users c, HEJIA_USER_BBS h set c.ask_expert = h.ask_expert  where h.USERBBSID = c.user_id and h.ask_expert > 0
      render :text => alert("您已经同意了会员【#{user.USERNAME}】成为问吧专家的申请！") # + js(top_load("self"))
    else
      user.ask_expert = 0
      user.save
      render :text => alert("您已经拒绝了会员【#{user.USERNAME}】成为问吧专家的申请！") # + js(top_load("self"))
    end
  end
  # 冻结用户
  def freeze_user
    user_id = params[:user_id].to_i
    date_time = params[:date_time]
    freeze_type = params[:freeze_type] #freeze_type值为 freeze_forever表示永久冻结 ,为freeze_two表示冻结两天,为freeze_other表示手动选择时间
    if freeze_type == 'freeze_forever'
      freeze_date = 25.year.from_now.to_s(:db)
    elsif freeze_type == 'freeze_two'
      freeze_date = 2.day.from_now.to_s(:db)
    elsif freeze_type == 'freeze_other'
      freeze_date = date_time + " " + Time.now.strftime("%H:%M:%S")
    else
      render :text => 'error'
    end
    HejiaUserBbs.update_all({:freeze_date => freeze_date}, :USERBBSID => user_id)
    render :text => freeze_date
  end
  
  # 撤销冻结用户
  def undo_freeze_user
    user_id = params[:user_id].to_i
    HejiaUserBbs.update_all("freeze_date = null", :USERBBSID => user_id)
    render :text => 'yes'
  end

  private
  def get_conditions
    return false unless pvalidate("和家会员列表","管理员","会员管理")
    @riqi1 = params[:riqi1]
    @riqi2 = params[:riqi2]
    @llogin1 = params[:llogin1]
    @llogin2 = params[:llogin2]
    @username = params[:username]
    @email = params[:email]
    @area = params[:area]
    @city = params[:city]
    @bbs_topic_count = params[:bbs_topic_count]
    @wenba_topic_count = params[:wenba_topic_count]

    @ask_expert = params[:ask_expert].to_i
    @user_type = params[:user_type].to_i
    @deco_id = params[:deco_id].to_i
    @conditions = "true"

    if pp(@username)
      @conditions += " and hub.USERNAME like '%#{@username}%'" unless @username.blank?
    end
    if pp(@email)
      @conditions += " and hub.USERBBSEMAIL like '%#{@email}%'" unless @email.blank?
    end
    @conditions += " and hub.CREATTIME >= '#{@riqi1} 0:0:0'" if pp(@riqi1)
    @conditions += " and hub.CREATTIME <= '#{@riqi2} 23:59:59'" if pp(@riqi2)
    @conditions += " and hub.LOGINDATE >= '#{@llogin1} 0:0:0'" if pp(@llogin1)
    @conditions += " and hub.LOGINDATE <= '#{@llogin2} 23:59:59'" if pp(@llogin2)

    if pp(@city) and @city != "0"
      @conditions += " and hub.CITY = #{@city}"
    else
      @conditions += " and hub.AREA = #{@area}" if pp(@area)
    end

    case @user_type
    when -500
      @conditions += " and hub.USERTYPE <> 100 and hub.USERTYPE <> 200  "
    when 100
      @conditions += " and hub.USERTYPE = 100"
    when 200
      @conditions += " and hub.USERTYPE = 200"
    end
    @conditions += " and hub.deco_id > 0" if @deco_id == 1
    @conditions += " and hub.deco_id = 0" if @deco_id == -1
    case @ask_expert
    when 1
      @conditions += " and hub.ask_expert < 0"
    when 2
      @conditions += " and hub.ask_expert = 0"
    when 3
      @conditions += " and hub.ask_expert > 0"
    end

    @model = HejiaUserBbs
    @sql = "select hub.USERBBSID, hub.USERNAME, hub.USERBBSEMAIL, hub.AREA, hub.CITY, hub.USERTYPE, hub.USERBBSTEL, hub.CREATTIME, hub.LOGINDATE, hub.ask_expert,hub.USERBBSSEX, hub.MSN, hub.QQ, hub.deco_id, hub.class_name "
    @sql += " from 51hejia.HEJIA_USER_BBS hub where #{@conditions} order by USERBBSID DESC limit #{@current_page - 1}, #{@per_page}"
    @count_sql = "select count(hub.USERBBSID) as total_hubs from 51hejia.HEJIA_USER_BBS hub where #{@conditions}"

    unless @bbs_topic_count.blank?
      @model = AskForumTopic
=begin
      @sql = "select hub.USERBBSID, hub.USERNAME, hub.USERBBSEMAIL, hub.AREA, hub.CITY, hub.USERTYPE, hub.USERBBSTEL, hub.CREATTIME, hub.LOGINDATE, hub.ask_expert,hub.USERBBSSEX, hub.MSN, hub.QQ, hub.deco_id, hub.class_name ,count(aft.user_id) as topic_count "
      @sql += " from 51hejia.ask_forum_topics aft, 51hejia.HEJIA_USER_BBS hub where aft.user_id=hub.USERBBSID1 and #{@conditions} and aft.is_delete = 0 group by aft.user_id having topic_count > #{@bbs_topic_count} order by topic_count desc limit #{@current_page - 1}, #{@per_page}"
      @count_sql = "select distinct hub.USERBBSID from 51hejia.ask_forum_topics aft, 51hejia.HEJIA_USER_BBS hub where aft.user_id=hub.USERBBSID and #{@conditions} and aft.is_delete = 0 group by aft.user_id having count(aft.user_id) >= #{@bbs_topic_count}"
=end
      @sql = "select hub.USERBBSID, hub.USERNAME, hub.USERBBSEMAIL, hub.AREA, hub.CITY, hub.USERTYPE, hub.USERBBSTEL, hub.CREATTIME, hub.LOGINDATE, hub.ask_expert,hub.USERBBSSEX, hub.MSN, hub.QQ, hub.deco_id, hub.class_name ,count(bt.user_id) as topic_count "
      @sql += " from 51hejia_forum.bbs_topics bt, 51hejia.HEJIA_USER_BBS hub where bt.user_id=hub.USERBBSID and #{@conditions} and bt.is_delete = 0 group by bt.user_id having topic_count > #{@bbs_topic_count} order by topic_count desc limit #{@current_page - 1}, #{@per_page}"
      @count_sql = "select distinct hub.USERBBSID from 51hejia_forum.bbs_topics bt, 51hejia.HEJIA_USER_BBS hub where bt.user_id=hub.USERBBSID and #{@conditions} and bt.is_delete = 0 group by bt.user_id having count(bt.user_id) >= #{@bbs_topic_count}"
    end

    unless @wenba_topic_count.blank?
      @model = AskZhidaoTopic
      @sql = "select hub.USERBBSID, hub.USERNAME, hub.USERBBSEMAIL, hub.AREA, hub.CITY, hub.USERTYPE, hub.USERBBSTEL, hub.CREATTIME, hub.LOGINDATE, hub.ask_expert,hub.USERBBSSEX, hub.MSN, hub.QQ, hub.deco_id, hub.class_name ,count(azt.user_id) as topic_count "
      @sql += " from 51hejia.ask_zhidao_topics azt, 51hejia.HEJIA_USER_BBS hub where azt.user_id = hub.USERBBSID and #{@conditions} and azt.is_delete = 0 group by azt.user_id having topic_count > #{@wenba_topic_count} order by topic_count desc limit #{@current_page - 1}, #{@per_page}"
      @count_sql = "select distinct hub.USERBBSID from 51hejia.ask_zhidao_topics azt, 51hejia.HEJIA_USER_BBS hub where azt.user_id = hub.USERBBSID and #{@conditions} and azt.is_delete = 0 group by azt.user_id having count(azt.user_id) >= #{@wenba_topic_count}"
    end
  end
  
end
