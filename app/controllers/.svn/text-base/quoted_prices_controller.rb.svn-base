class QuotedPricesController < ApplicationController
  
  layout 'deco'
  before_filter :find_firm
  #before_filter :member_validate

  def index
    if current_deco_id > 0
      @firm = DecoFirm.find(current_deco_id)
      @quoted_prices = @firm.quoted_prices.paginate :page => params[:page],:per_page => 10#,:order => "position"
    else
      @quoted_prices = @firm.quoted_prices.paginate :page => params[:page],:per_page => 10#,:order => "position"
    end
  end

  def show
    @quoted_price = QuotedPrice.find(params[:id])
  end

  def new
    @quoted_price = QuotedPrice.new
  end

  def create
    @quoted_price = QuotedPrice.new(params[:quoted_price])
    if @quoted_price.save
      #flash[:notice] = 'QuotedPrice was successfully created.'
      #redirect_to quoted_prices_path
      render :text => alert("操作成功：记录已创建!") + js(top_load("/quoted_prices"))
    else
      # render :text => alert("操作失败,请验证录入数据")+js(top_load("/quoted_prices/new"))
      render :action => 'new'
    end
  end

  def edit
    @quoted_price = QuotedPrice.find(params[:id])
  end

  def update
    @quoted_price = QuotedPrice.find(params[:id])
    if @quoted_price.update_attributes(params[:quoted_price])
      render :text => alert("操作成功：记录已修改!") + js(top_load("/quoted_prices"))
      #flash[:notice] = 'QuotedPrice was successfully updated.'
      #redirect_to :action => 'show', :id => @quoted_price
    else
      render :action => 'edit'
    end
  end

  def destroy
    QuotedPrice.find(params[:id]).destroy
    redirect_to quoted_prices_path
  end

  def sort_by_position
    unsorted_list=QuotedPrice.find(params[:quoted_prices],:select => 'position').map { |e| e.position }
    sorted_list=unsorted_list.sort
    new_hash_data=Hash[*params[:quoted_prices].zip(sorted_list).flatten]
    new_hash_data.each do | key,value|
      QuotedPrice.update(key,:position => value)
    end
    render :nothing => true 
  end

end
