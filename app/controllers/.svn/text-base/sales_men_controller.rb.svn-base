# encoding: utf-8
class SalesMenController < ApplicationController

  layout 'decocompany'
  
  def index
    name = params[:name]
    city = City.find_by_name_en(params[:city]).blank? ? nil : params[:city]
    @sales_men = SalesMan.valid.with_name(name).with_city(city).paginate :page => params[:page], :per_page => 20
  end

  def new 
    @sales_man = SalesMan.new
  end

  def create 
    @sales_man = SalesMan.new(params[:sales_man])
    if @sales_man.save
      flash[:notice] = "创建成功！"
      redirect_to :action => :index 
    else
      flash[:notice] = "创建失败！#{@sales_man.errors.full_messages}"
      render :action => :new 
    end
  end

  def edit
    @sales_man = SalesMan.find params[:id] 
  end


  def update
    @sales_man = SalesMan.find(params[:id])
    @sales_man.attributes = params[:sales_man]
    if @sales_man.save
      flash[:notice] = "修改成功！"
      redirect_to :action => :index 
    else
      flash[:notice] = "创建失败！#{@sales_man.errors.full_messages}"
      render :action => :edit 
    end
  end

  def destroy
    sales_man = SalesMan.find_by_id(params[:id])
    if sales_man.hidden
      flash[:notice] = "删除成功！"
    else
      flash[:notice] = "删除失败!"
    end
    redirect_to :action => :index 
  end

  # 在返回值上晕了我半天！
  def destroy_all
    sales_men = SalesMan.find_all_by_id(params[:ids].split(","))
    sales_men.each do |sales_man|
      sales_man.hidden
    end
    respond_to do |format|
      format.json { render :json => sales_men.to_json }
    end
  end

end
