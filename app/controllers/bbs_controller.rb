class BbsController < ApplicationController

  def topic_stat_list
    conditions = []
    #conditions << "log_date = '2009-06-15'"
    #某些特殊的group子句需要特殊的统计recordcount的方式
    conditions = conditions.join(" and ")
    conditions = nil if conditions == ""
    params[:recordcount] = TopicStat.count("id", :conditions => conditions, :group => "log_date").length if params[:recordcount].nil?
    @stats = paging_record options = {
      "model" => TopicStat,
      "pagesize" => 15,   #每页记录数
      "listsize" => 10,  #同时显示的页码数
      "select" => "id,topic_num,ip_num,c1,c2,c3,c4,c5,i1,i2,i3,i4,i5,log_date,created_at",
      "conditions" => conditions,
      "order" => "id desc",
      "group" => "log_date"
    }
  end

  def admin_operation
    conditions = []
    @logs = paging_record options = {
      "model" => AdminLog,
      "pagesize" => 20,   #每页记录数
      "listsize" => 10,  #同时显示的页码数
      #"select" => "id,topic_num,ip_num,log_date,created_at",
      "conditions" => conditions.join(" and "),
      "order" => "id desc"
    }
  end

  def bbs_word_filter
    return false unless pvalidate("浏览过滤关键字列表","管理员","论坛管理")
    word_filter
    render :template => "/common/word_filter"
  end

  def word_filter_del
    return false unless pvalidate("删除过滤关键字","管理员","论坛管理","问吧管理")
    begin
      FilterWord.delete_all "id in (#{params[:ids]})" unless params[:ids].nil?
      render :text => js(top_load("self"))
    rescue Exception => e
      render :text => alert_error("操作失败：#{get_error(e)}")
    end
  end

  def word_filter_save
    return false unless pvalidate("保存过滤关键字","管理员","论坛管理","问吧管理")
    old = params[:old].split("\r\n")
    new = params[:new].split("\r\n")
    rv = nil
    load_url = nil
    rv = "操作失败：过滤词必须填写!" if old.length == 0
    if rv.nil?
      begin
        0.upto(old.length-1) do |i|
          oldword = old[i]
          if pp(oldword)
            if pp(new[i])
              newword = new[i]
            else
              newword = "***"
              #oldword.length.times { |j| newword += "*" }
            end
            FilterWord.create(:old=>oldword,:new=>newword,:sort_id=>params[:sort_id])
          end
        end
        rv = "操作成功：过滤词已添加!"
        load_url = "self"
      rescue Exception => e
        rv ="操作失败：#{get_error(e)}"
      end
    end
    rv = alert(rv.to_s)
    rv += js(top_load(load_url)) unless load_url.nil?
    render :text => rv
  end

  def topic_list
    return false unless pvalidate("和家会员列表","管理员","论坛管理")
    @riqi1 = params[:riqi1]
    @riqi2 = params[:riqi2]
    @keyword = trim(params[:keyword])
    @username = trim(params[:username])
    cd = "is_delete=0"
    cd += " and subject like '%%#{@keyword}%%'" if pp(@keyword)
    cd += " and created_at >= '#{@riqi1} 0:0:0'" if pp(@riqi1)
    cd += " and created_at <= '#{@riqi2} 23:59:59'" if pp(@riqi2)
      
    if pp(@username)
      if @username.to_i==0
        user_id = HejiaUserBbs.find_by_USERNAME(@username,:select=>"USERBBSID").USERBBSID
      else
        user_id = @username
      end
      cd += " and user_id = #{user_id}"
    end
    h = Hash.new
    h["model"] = AskZhidaoTopic
    h["pagesize"] = 20 #每页记录数
    h["listsize"] = 10 #同时显示的页码数
    h["select"] = "id, subject, post_counter, user_id, created_at"
    #h["primary_key"] = "USERBBSID"
    h["conditions"] = cd
    h["order"] = "id desc"
    @topics = paging_record(h)
  end

  def topic_del
    return false unless pvalidate("和家会员列表","管理员","论坛管理")
    begin
      AskZhidaoTopic.update(params[:id], :isdelete => 1) unless params[:id].nil?
      AskZhidaoTopic.update_all("is_delete = 1", "id in (#{params[:ids]})") unless params[:ids].nil?
      render :text => js(top_load("self"))
    rescue Exception => e
      render :text => alert_error("操作失败：#{get_error(e)}")
    end
  end

  def forum_tag_handle
    return false unless pvalidate("处理帖子转移","管理员","论坛管理")
    conditions = []
    conditions << "is_delete=0 and tag_id > 42 "
    @topics = paging_record options = {
      "model" => BbsTopic,
      "pagesize" => 50,   #每页记录数
      "listsize" => 10,  #同时显示的页码数
      "select" => "id, subject,area_id,tag_id,parent_tag_id,created_at",
      "conditions" => conditions.join(" and "),
      "order" => "id desc"
    }
    @tags=BbsTag.find(:all,:select => "id,name",:conditions=>"id>=8")

  end

  def forum_del
    return false unless pvalidate("删除帖子记录","管理员","论坛管理")
    ids = trim(params[:ids].to_s)
    if ids.length > 0
      begin
        BbsTopic.update_all("is_delete = 1", "id in (#{ids})")
        @rv = "已成功删除记录!"
      rescue Exception => e
        @rv = "操作失败：#{get_error(e)}"
      end
    else
      @rv = "请至少选择一条记录！"
    end
    myrender(@rv, @ru)
  end

  def forum_update
    return false unless pvalidate("批量转移帖子","管理员","论坛管理")
    tag_id = params[:tag_id].to_s
    area_id = params[:area_id].to_s
    ids = trim(params[:ids].to_s)
    sql = []

    unless tag_id.blank?
      parent_tag_id = BbsTag.find(:first,:select=>"parent_id",:conditions=>"id=#{tag_id}")["parent_id"]
      sql << "tag_id = #{tag_id}"
      sql << "parent_tag_id = #{parent_tag_id}"
    end
    unless area_id.blank?
      sql << "area_id = #{area_id}"
    end
   
    if (tag_id.blank? && area_id.blank?) || ids.blank?
      @rv = "操作失败：参数不足！请重新选择！"
    else
      begin
        BbsTopic.update_all(sql.join(", "), "id in (#{ids})")
        @rv = "您选择的帖子已成功转移!"
      rescue Exception => e
        @rv = "操作失败：#{get_error(e)}"
      end
    end


    myrender(@rv, @ru)
  end
end
