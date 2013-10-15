class HejiaKeywordTagController < ApplicationController
  helper :layout
  layout 'bad_words'
  before_filter :check_tag,:only =>:update_tag

  def index

    @fathertags = HejiaKeywordToTag.find(:all,:conditions => 'fathername is not null')

  end

  #新建标签对应大类
  def new_father_tag
    if request.post? && params[:submit]
      @hejia_keyword_tag = HejiaKeywordToTag.new
      @hejia_keyword_tag.fathername = params[:father_name]
      @hejia_keyword_tag.created_at = @hejia_keyword_tag.updated_at = Time.now.strftime("%Y-%m-%d %H:%M:%S")
      if @hejia_keyword_tag.save
        flash[:now] = '新建成功!'
      else
        flash[:now] = '新建失败,请重新提交!'
      end
    end
  end

  #新建大类下面的关键词对应的风格标签
  def new_keyword_tag
    if request.post? && params[:submit]
      @tagname = HejiaKeywordToTag.find params[:fatherid]
      if @tagname && !@tagname.fathername.nil?
        if HejiaKeywordToTag.find(:first,:conditions =>["fatherid = ? and keyword = ?",@tagname.id,params[:keyword]])
          return flash[:now] = '添加失败:此标签已经添加,请重新添加不同的标签'
        end
        @new_keyword_tag = HejiaKeywordToTag.new
        @new_keyword_tag.fatherid = @tagname.id
        @new_keyword_tag.keyword = params[:keyword]
        @new_keyword_tag.tag = params[:tag]
        @new_keyword_tag.created_at = @new_keyword_tag.updated_at = Time.now.strftime("%Y-%m-%d %H:%M:%S")
        if @new_keyword_tag.save
          flash[:now] = '新建标签对应成功!'
        else
          flash[:now] = '新建失败,请重新提交!'
        end
      else
        flash[:now] = '参数错误!请重新选择内别新建标签对应'
      end
    else
      if !params[:id].blank?
        @tagname = HejiaKeywordToTag.find params[:id]
        if @tagname && !@tagname.fathername.nil?
           @tagname
        else
          flash[:now] = '参数错误!请重新选择内别新建标签对应'
        end
      else
         flash[:now] = '参数错误!请重新选择内别新建标签对应'
      end
    end
  end

  #查看关键词标签对应

  def view_keyword_tag
    if params[:id]
      @viewkey = HejiaKeywordToTag.find(:all,:conditions =>["fatherid = ?",params[:id]])
    end
  end

  #更新关键词标签
  def update_tag
    if request.post?
      self_tag = HejiaKeywordToTag.find(:first,:conditions =>["fatherid = ? and keyword = ?",@k_tag.fatherid,params[:keyword]])
      if self_tag && self_tag[:id] != @k_tag[:id]
        return flash[:now] = '添加失败:此标签已经添加,请重新添加不同的标签'
      else
        @k_tag.update_attributes :keyword =>params[:keyword],:tag =>params[:tag]
        flash[:now] = '更新成功'
      end
    end
  end


  def check_tag
    @k_tag = HejiaKeywordToTag.find params[:id]
    if @k_tag && @k_tag.fatherid
      @k_tag
    else
      return flash[:now] = '没有对应的标签'
    end
  end





end
