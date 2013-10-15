class Decos::DecoServicesController < ApplicationController
  layout "deco"
  before_filter :find_firm
  before_filter :find_deco_service, :only => [:edit, :update, :destroy]

  def index
    @deco_services = @firm.deco_services.find(:all, :order=>"created_at desc")
  end

  def new
    @deco_service = DecoService.new
  end

  def create
    @deco_service = @firm.deco_services.build(params[:deco_service])
    if @deco_service.save
      save_pictures
      flash[:notice] = "服务承诺创建成功"
      redirect_to :action => :index
    else
      render :action => :new
    end
  end

  def edit
    render :action => :new
  end

  def update
    if @deco_service.update_attributes(params[:deco_service])
      save_pictures if params[:pictures]
      flash[:notice] = "服务承诺修改成功"
      redirect_to :action => :index
    else
      render :action => :edit
    end
  end

  def destroy
    if @deco_service.destroy
      flash[:notice] = "删除成功"
      redirect_to :action => :index
    else
      flash[:error] = "删除错误"
      redirect_to :action => :index
    end
  end

  private

  def find_deco_service
    @deco_service = DecoService.find(params[:id])
  end

  def save_pictures
    return if params[:pictures].nil?
    # 保存图片附件
    params[:pictures].each do |picture|
      if @picture = Picture.find_by_image_id(picture[:image_id])
        @picture.update_attributes(picture)
      else
        @picture = Picture.new(picture)
        @picture.item =  @deco_service
        @picture.save
      end
    end
    # 设置主图
    Hejia[:cache].delete "deco_service:#{@deco_service.id}:master_picture"
    master_picture_image_id = params[:pictures][0][:is_master]
    if master_picture_image_id
      Picture.update_all("is_master = 0 ",["item_type = 'DecoService' and item_id = (?)",@deco_service.id])
      Picture.update_all("is_master = 1 ",:image_id => master_picture_image_id)
    end
  end
end
