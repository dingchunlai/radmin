class AdSpacesController < ApplicationController

  def index
    @keyword = params[:keyword]
    @sort = params[:sort].to_s.strip
    cond = []
    unless @keyword.blank?
      if @keyword.to_i > 0
        cond << "ad_id = #{@keyword}"
      else
        cond << "code like '%#{@keyword}%'"
      end
    end
    cond << "code like '#{@sort}%'" unless @sort.blank?
    if cond.length == 0
      cond = nil
    else
      cond = cond.join(" and ")
    end
    @spaces = AdSpace.paginate :per_page => 13,
      :conditions => cond,
      :page => params[:page], :order => 'is_using, id desc'
    render :layout => 'ad'
  end

  def update
    space = AdSpace.find(params[:id])
    space.attributes = params[:space]
    if space.save
      AdSpace.clear_cache(space.code)
      render :text => space.id.to_s
    else
      render :text => '未知错误，保存失败！', :status => 500
    end
  end

  def create
    space = AdSpace.new
    space.attributes = params[:space]
    if space.save
      AdSpace.clear_cache(space.code)
      render :text => '0'
    else
      render :text => '未知错误，保存失败！', :status => 500
    end
  end

  def destroy
    space = AdSpace.find(params[:id])
    AdSpace.clear_cache(space.code)
    space.destroy
    if space.save
      render :text => space.id.to_s
    else
      render :text => '未知错误，删除失败！', :status => 500
    end
  end

  def is_using_change
    if current_staff.admin?
      space = AdSpace.find(params[:id])
      space.is_using = 1 - space.is_using
      if space.save
        AdSpace.clear_cache(space.code)
        render :text => space.is_using.to_s
      else
        render :text => '未知错误，修改启用状态失败！'
      end
    else
      render :text => '只有管理员可以执行修改启用状态操作！'
    end
  end

end
