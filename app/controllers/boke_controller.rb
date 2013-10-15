class BokeController < ApplicationController
  ## 博文列表
  def topics
    return false unless pvalidate("浏览问吧问题列表","管理员","问吧管理")
    @riqi1 = params[:riqi1]
    @riqi2 = params[:riqi2]
    @username = trim(params[:username])
    @keyword = params[:keyword]
    cd = "is_delete = 0"
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

    @recordcount = AskBlogTopic.count("id",:conditions => cd)

    h = Hash.new
    h["model"] = AskBlogTopic
    h["pagesize"] = 20 #每页记录数
    h["listsize"] = 10 #同时显示的页码数
    h["select"] = "id, subject, user_id, description, created_at"
    h["conditions"] = cd
    h["order"] = "created_at desc"
    @topics = paging_record(h)
  end


  ## 博文回复列表
  def posts
    return false unless pvalidate("浏览问吧问题列表","管理员","问吧管理")
    @riqi1 = params[:riqi1]
    @riqi2 = params[:riqi2]
    @username = trim(params[:username])
    cd = "is_delete = 0"
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

    @recordcount = AskBlogTopicPost.count("id",:conditions => cd)

    h = Hash.new
    h["model"] = AskBlogTopicPost
    h["pagesize"] = 20 #每页记录数
    h["listsize"] = 10 #同时显示的页码数
    h["select"] = "id, blog_topic_id, user_id, content, created_at"
    h["conditions"] = cd
    h["order"] = "created_at desc"
    @posts = paging_record(h)
  end


  ## 删除主帖恢复
  def delete_all
    ids = params[:ids]
    unless ids.blank?
      if params[:model_type].to_s == "AskBlogTopic"
        AskBlogTopic.update_all("is_delete = 1", "id in (#{ids})")
      else
        AskBlogTopicPost.update_all("is_delete = 1", "id in (#{ids})")
      end
    end
    if params[:model_type].to_s == "AskBlogTopic"
      redirect_to "/boke/topics?&riqi1=#{params[:riqi1]}&riqi2=#{params[:riqi2]}&username=#{params[:username]}&keyword=#{params[:keyword]}"
    else
      redirect_to "/boke/posts?&riqi1=#{params[:riqi1]}&riqi2=#{params[:riqi2]}&username=#{params[:username]}"
    end
  end


  def operations
    @riqi1 = params[:riqi1]
    @riqi2 = params[:riqi2]
    @wu_state = params[:wu_state]
    @username = trim(params[:username])
    @radmin_username = trim(params[:radmin_username])

    conditions = "true"
    if pp(@username)
      if @username.to_i==0
        user_ids = HejiaUserBbs.find(:all,:conditions => ["USERNAME like ?","%#{@username}%"],:select=>"USERBBSID").map{|u|u.USERBBSID}
        conditions += " and user_id in (#{user_ids.join(',')})" unless user_ids.blank?
      else
        user_id = @username
        conditions += " and user_id = #{user_id}"
      end
    end
    conditions += " and state = '#{@wu_state}'" if pp(@wu_state)
    conditions += " and updated_at >= '#{@riqi1} 0:0:0'" if pp(@riqi1)
    conditions += " and updated_at <= '#{@riqi2} 23:59:59'" if pp(@riqi2)
    if pp(@radmin_username)
      if @radmin_username.to_i==0
        radmin_user_ids = HejiaStaff.find(:all,:conditions => ["name like ?","%#{@radmin_username}%"]).map{|u|u.id}
        conditions += " and user_id in (#{radmin_user_ids})" unless radmin_user_ids.blank?
      else
        conditions += "radmin_user_id = #{@radmin_username.to_i}"
      end
    end

    @recordcount = BokeUser.count("id",:conditions => conditions)

    h = Hash.new
    h["model"] = BokeUser
    h["pagesize"] = 20 #每页记录数
    h["listsize"] = 10 #同时显示的页码数
    h["select"] = "*"
    h["conditions"] = conditions
    h["order"] = "created_at desc"
    @boke_users = paging_record(h)
  end

  ## 问吧用户批量操作
  def operation_all
    @wu_ids = params[:wu_ids]
    @state = params[:state]
    @reason = params[:reason]
    @freeze_time = params[:freeze_time]
    unless @wu_ids.blank?
      @boke_users = BokeUser.find(:all,:conditions => ["id in (#{@wu_ids})"])
      for boke_user in @boke_users
        boke_user.state = @state
        boke_user.reason = @reason
        boke_user.freeze_time = @freeze_time
        boke_user.radmin_user_id = session['user:staff:id']
        boke_user.updated_at = Time.now.to_s(:db)

        ## 禁止访问
        if @state == "2"
          HejiaUserBbs.update_all("freeze_date = '#{@freeze_time}'", "USERBBSID = #{boke_user.user_id}")
        elsif @state == "0"
          HejiaUserBbs.update_all("freeze_date = '#{Time.now.to_s(:db)}'", "USERBBSID = #{boke_user.user_id}")
        end
        boke_user.save
      end
    end

    redirect_to "/boke/operations?&riqi1=#{params[:riqi1]}&riqi2=#{params[:riqi2]}&username=#{params[:username]}&radmin_username=#{params[:radmin_username]}&wu_state=#{params[:wu_state]}"
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
        @boke_user = BokeUser.find_by_user_id(@hu.USERBBSID)
        if @boke_user.blank?
          ## insert into boke_users(user_id,name,regist_time,ip_address) SELECT USERBBSID,USERNAME,CREATTIME,LOGINIP FROM HEJIA_USER_BBS
          @boke_user = BokeUser.new(:user_id => @hu.USERBBSID,:ip_address => @hu.LOGINIP, :regist_time => @hu.CREATTIME, :name => @hu.USERNAME, :radmin_user_id => session['user:staff:id'])
        else
          if @boke_user.freeze_time and @boke_user.freeze_time < Time.now
            @boke_user.state = "0"
            @boke_user.save
          end
        end
      end
    end
  end

  ## 创建问吧用户管理
  def create_boke_user
    @boke_user = BokeUser.find_by_user_id(params[:boke_user][:user_id])
    if @boke_user
      @boke_user.update_attributes(params[:boke_user])
    else
      @boke_user = BokeUser.create(params[:boke_user])
      @boke_user.created_at = Time.now.to_s(:db)
    end
    @boke_user.updated_at = Time.now.to_s(:db)
    @boke_user.radmin_user_id = session['user:staff:id']
    @boke_user.save


    @hu = @boke_user.user
    if @boke_user.state == "2"
      @hu.freeze_date = @boke_user.freeze_time
    elsif @boke_user.state == "0"
      @hu.freeze_date = Time.now.to_s(:db)
    end
    @hu.save

    ## 删除博文
    if params[:bowen] == "1"
      AskBlogTopic.update_all("is_delete = 1","user_id = #{@boke_user.user_id}")
    end

=begin
## 锁定博客
if params[:lock] == "1"
      AskBlogTopic.update_all("is_lock = 1","user_id = #{@boke_user.user_id}")
    end
=end

    ## 删除回复
    if params[:huifu] == "1"
      AskBlogTopicPost.update_all("is_delete = 1","user_id = #{@boke_user.user_id}")
    end

    ## 删除站内短信
    if params[:duanxin] == "1"
      AskUserMessage.update_all("is_delete = 1","user_id = #{@boke_user.user_id}")
    end

    ## 删除博客头像
    if params[:touxiang] == "1"
      @hu.update_attributes(:HEADIMG => "http://member.51hejia.com/images/headimg/default.gif")
    end

    ## 删除博客签名
    if params[:qianming] == "1"
      @hu.update_attributes(:USERBBSREADME => nil)
    end

    redirect_to :action => "users", :username => @boke_user.name
  end

  
  def boke_list
    return false unless pvalidate("浏览评论","管理员","文章编辑")
    @user_id=trim(params[:user_id])
    user_id=0
    user_id=@user_id if(@user_id.to_i>0)
    conditions = []
    conditions << " user_id =#{user_id}"
    conditions << " is_delete = 0 "
    @boke = paging_record options = {
      "model" => AskBlogTopic,
      "pagesize" => 30,   #每页记录数
      "listsize" => 10,  #同时显示的页码数
      "select" => " id,user_id,subject,created_at ",
      "conditions" => conditions.join(" and "),
      "order" => "id desc"
    }
     
  end
  
  def boke_del

    return false unless pvalidate("删除其用户博客记录","管理员","文章编辑")
    ids = trim(params[:ids].to_s)
    if ids.length > 0
      begin
        AskBlogTopic.update_all("is_delete = 1", "id in (#{ids})")
        @rv = "已成功删除记录!"
      rescue Exception => e
        @rv = "操作失败：#{get_error(e)}"
      end
    else
      @rv = "请至少选择一条记录！"
    end
    myrender(@rv, @ru)
  
  end

  def boke_del_all
    return false unless pvalidate("删除其用户所有博客记录","管理员","文章编辑")
    user_id=trim(params[:user_id])
    if(user_id.to_i>0)
      begin
        AskBlogTopic.update_all("is_delete = 1", "user_id = (#{user_id})")
      rescue Exception => e
        @rv = "操作失败：#{get_error(e)}"
      end
      @rv = "已成功删除记录!"
    else
      @rv = "请填写用户编码号!"
    end
    myrender(@rv, @ru)
  end
end
