class Decos::DecoIdeasController < ApplicationController
  layout "deco"
  before_filter :find_firm
  before_filter :find_deco_idea, :only => [:edit, :update, :destroy]
  
  def index
    @deco_ideas = @firm.deco_ideas.find(:all, :order=>"created_at desc")
  end
  
  def new
    @deco_idea = DecoIdea.new
  end

  def create
    @deco_idea = @firm.deco_ideas.build(params[:deco_idea])
    if @deco_idea.save
      save_pictures
      flash[:notice] = "装修理念创建成功"
      redirect_to :action => :index
    else
      render :action => :new
    end
  end
  
  def edit
    @pictures = @deco_idea.pictures
    render :action => :new
  end
  
  def update
    if @deco_idea.update_attributes(params[:deco_idea])
      save_pictures if params[:pictures]
      flash[:notice] = "修改成功"
      redirect_to :action => :index
    else
      render :action => :edit
    end
  end
  
  def destroy
    if @deco_idea.destroy
      flash[:notice] = "删除成功"
      redirect_to :action => :index
    else
      flash[:error] = "删除错误"
      redirect_to :action => :index
    end
  end

  #限制商家的确认预约定单数;
  def update_idea_name
    if params[:company_id] && params[:idea_name] != "" && params[:idea_name].squeeze(" ") != " "
      REDIS_DB.set "deco_idea_#{params[:company_id]}", params[:idea_name]
    end
    redirect_to :action => :index
  end

  private

  def find_deco_idea
    @deco_idea = DecoIdea.find(params[:id])
  end

  def save_pictures
    return if params[:pictures].nil?
    # 保存图片附件
    params[:pictures].each do |picture|
      if @picture = Picture.find_by_image_id(picture[:image_id])
        @picture.update_attributes(picture)
      else
        @picture = Picture.new(picture)
        @picture.item =  @deco_idea
        @picture.save
      end
    end
    # 设置主图
    Hejia[:cache].delete "deco_idea:#{@deco_idea.id}:master_picture"
    master_picture_image_id = params[:pictures][0][:is_master]
    if master_picture_image_id
      Picture.update_all("is_master = 0 ",["item_type = 'DecoIdea' and item_id = (?)",@deco_idea.id])
      Picture.update_all("is_master = 1 ",:image_id => master_picture_image_id)
    end
  end

  
end
