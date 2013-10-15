class RelateTagController < ApplicationController
  
  helper :layout
  layout "relate_tag"
  
  def index
    @relate_tag = RelateTag.new
    @title = "标签对应"
    @article_tag = params[:article_tag]
    @diary_tag = params[:diary_tag]
    @tags = RelateTag.search_for(params).paginate :per_page => 30, :page => params[:page], :order => "id desc"
  end
  
  def new
  end
  
  def create
    relate_tag = RelateTag.new params[:relate_tag]
    if relate_tag.save
      flash[:notice] = "添加成功"
    else
      flash[:error] = "错误:已有该记录"
    end
    redirect_to :action => "index"
  end
  
  def delete
    ids = params[:tag_ids].nil? ? [] : params[:tag_ids]
    ids.each do |id|
      RelateTag.delete(id)
    end
    redirect_to :action => "index"
  end
  
end