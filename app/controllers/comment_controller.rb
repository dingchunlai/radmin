# -*- coding: utf-8 -*-
class CommentController < ApplicationController

  def show
    @sort_id = params[:sort_id].to_i
    @theme_id = params[:theme_id]
    if @theme_id.blank?
      render :file => "#{RAILS_ROOT}/public/404.html", :status => 404
      return false
    end
    @nick_name = params[:nick_name] || ""
    @comment_sort = eval("COMMENT_SORT" + @sort_id.to_s) if @sort_id!=0
    @deco_id = current_deco_id
    conditions = []
    conditions << "is_delete = 0"
    conditions << "theme_id = #{@theme_id.to_s}"
    conditions << "sort_id = #{@sort_id.to_s}"
    @comments = paging_record options = {
      "model" => Comment,
      "pagesize" => 10,   #每页记录数
      "listsize" => 10,  #同时显示的页码数
      "select" => "id,theme_id,sort_id,nickname,content,reply,created_at,updated_at,is_delete,pv1,pv2,pv3,pv4,pv5,pv6,pv7",
      "conditions" => conditions.join(" and "),
      "order" => "id desc"
    }
    render :layout => false
  end

  def show_1
    @sort_id = params[:sort_id].to_i
    @theme_id = params[:theme_id]
    @nick_name = params[:nick_name] || ""
    @comment_sort = eval("COMMENT_SORT" + @sort_id.to_s) if @sort_id!=0
    @deco_id = current_deco_id
    conditions = []
    conditions << "is_delete = 0"
    conditions << "theme_id = #{@theme_id.to_s}"
    conditions << "sort_id = #{@sort_id.to_s}"
    @comments = paging_record options = {
      "model" => Comment,
      "pagesize" => 10,   #每页记录数
      "listsize" => 10,  #同时显示的页码数
      "select" => "id,theme_id,sort_id,nickname,content,reply,created_at,updated_at,is_delete,pv1,pv2,pv3,pv4,pv5,pv6,pv7",
      "conditions" => conditions.join(" and "),
      "order" => "id desc"
    }
    render :layout => false
  end

  def comment_addnew
    content = trim(params[:content])
    if pp(content) && pp(params[:nickname])
      begin
        comment = Comment.new
        comment.nickname = iconv_gb2312(params[:nickname])
        comment.content = iconv_gb2312(content)
        comment.theme_id = params[:theme_id]
        comment.sort_id = params[:sort_id].to_i
        comment.created_at = getnow()
        comment.updated_at = getnow()
        comment.pv1 = params[:pv1].to_i unless params[:pv1].nil?
        comment.pv2 = params[:pv2].to_i unless params[:pv2].nil?
        comment.pv3 = params[:pv3].to_i unless params[:pv3].nil?
        comment.pv4 = params[:pv4].to_i unless params[:pv4].nil?
        comment.pv5 = params[:pv5].to_i unless params[:pv5].nil?
        comment.pv6 = params[:pv6].to_i unless params[:pv6].nil?
        comment.pv7 = params[:pv7].to_i unless params[:pv7].nil?
        comment.save
        render :text => alert("评论添加成功!") + js("window.open('#{params[:r_url]}','_top');")
      rescue Exception => e
        render :text => alert("操作失败：#{get_error(e)}")
      end
    else
      render :text => alert("评论内容必须填写!")
    end
  end

  def comment_reply
    reply = trim(params[:reply])
    if pp(reply)
      begin
        Comment.update_all("reply = '#{reply}'", "id in (#{params[:ids]})") unless params[:ids].nil?
        render :text => alert("评论回复成功!") + js(top_load("self"))
      rescue Exception => e
        render :text => alert_error("操作失败：#{get_error(e)}")
      end
    else
      render :text => alert("回复内容必须填写!") + js("parent.document.getElementById('submit_button').disabled = false;")
    end
  end

  def deco_reply(rv="",load_url=nil)
    rv = "参数不足!" if params[:reply].nil? || params[:comment_id].nil?
    rv = "你没有权限执行该操作!" if current_deco_id == 0
    if rv == ""
      begin
        Comment.update_all("reply = '#{params[:reply]}'", "id = #{params[:comment_id]}")
        load_url = "self"
      rescue Exception => e
        rv = "操作失败：#{get_error(e)}"
      end
    end
    myrender(rv, load_url)
  end

  def comment_list
    return false unless pvalidate("浏览评论","管理员","评论管理")
    conditions = []
    conditions << "is_delete = 0"
    @comments = paging_record options = {
      "model" => Comment,
      "pagesize" => 14,   #每页记录数
      "listsize" => 10,  #同时显示的页码数
      "select" => "id,theme_id,sort_id,nickname,content,reply,created_at,updated_at,is_delete,pv1,pv2,pv3,pv4,pv5,pv6,pv7",
      "conditions" => conditions.join(" and "),
      "order" => "id desc"
    }
    @comment_sort = COMMENT_SORT1
  end

  def comment_del
    return false unless pvalidate("删除评论","管理员","评论管理")
    begin
      Comment.destroy_all("id in (#{params[:ids]})") unless params[:ids].nil?
      render :text => js(top_load("self"))
    rescue Exception => e
      render :text => alert_error("操作失败：#{get_error(e)}")
    end
  end
  
  def reply_list
    return false unless pvalidate("浏览评论","管理员","评论管理")
    @content = trim(params[:content])
    @entity_id=trim(params[:entity_id])
    time_num=trim(params[:time_num])
    time_way=trim(params[:time_way])
    conditions = []
    if(time_num.to_i>0)
      @time_num=time_num
      if time_way=="month"
        conditions<< " created_at >'#{time_num.to_i.months.ago.strftime("%Y-%m-%d %H:%M:%S")}'"
        @month_selected="selected"
      end
      if time_way=="day"
        conditions<< " created_at > '#{time_num.to_i.days.ago.strftime("%Y-%m-%d %H:%M:%S")}'"
        @day_selected="selected"
      end
      if time_way=="hour"
        conditions<< " created_at > '#{time_num.to_i.hours.ago.strftime("%Y-%m-%d %H:%M:%S")}'"
        @hour_selected="selected"
      end
    else
      conditions << " created_at >'#{6.months.ago.strftime("%Y-%m-%d %H:%M:%S")}'"
    end

    conditions << " is_delete = -1 "
    conditions << "( content like '%#{@content}%')" if (@content.length > 0)
    conditions << "( entity_id=#{@entity_id})" if (@entity_id.to_i > 0)

    @replies = paging_record options = {
      "model" => Reply,
      "pagesize" => 50,   #每页记录数
      "listsize" => 10,  #同时显示的页码数
      "select" => "id,entity_id,content,created_at,guest_email",
      "conditions" => conditions.join(" and "),
      "order" => "id desc"
    }
     
  end

  def replies
    return false unless pvalidate("浏览评论","管理员","评论管理")
    @content = trim(params[:content])
    @entity_id=trim(params[:entity_id])
    time_num=trim(params[:time_num])
    time_way=trim(params[:time_way])
    conditions = []
    if(time_num.to_i>0)
      @time_num=time_num
      if time_way=="month"
        conditions<< " created_at >'#{time_num.to_i.months.ago.strftime("%Y-%m-%d %H:%M:%S")}'"
        @month_selected="selected"
      end
      if time_way=="day"
        conditions<< " created_at > '#{time_num.to_i.days.ago.strftime("%Y-%m-%d %H:%M:%S")}'"
        @day_selected="selected"
      end
      if time_way=="hour"
        conditions<< " created_at > '#{time_num.to_i.hours.ago.strftime("%Y-%m-%d %H:%M:%S")}'"
        @hour_selected="selected"
      end
    else
      conditions << " created_at >'#{6.months.ago.strftime("%Y-%m-%d %H:%M:%S")}'"
    end

    conditions << " is_delete = 0 "
    conditions << "( content like '%#{@content}%')" if (@content.length > 0)
    conditions << "( entity_id=#{@entity_id})" if (@entity_id.to_i > 0)

    @replies = paging_record options = {
      "model" => Reply,
      "pagesize" => 50,   #每页记录数
      "listsize" => 10,  #同时显示的页码数
      "select" => "id,entity_id,content,created_at,guest_email",
      "conditions" => conditions.join(" and "),
      "order" => "id desc"
    }

  end


  ## 审核通过
  def replies_examine
    return false unless pvalidate("删除评论","管理员","评论管理")
    Reply.update_all("is_delete = 0", "id in (#{params[:ids]})") unless params[:ids].nil?
    redirect_to :back
  end

  def replies_del
    return false unless pvalidate("删除评论","管理员","评论管理")
    Reply.destroy_all("id in (#{params[:ids]})") unless params[:ids].nil?
    redirect_to :back
  end
end
