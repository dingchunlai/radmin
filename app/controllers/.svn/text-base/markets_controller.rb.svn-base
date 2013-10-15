class MarketsController < ProductsController
  before_filter :check_product_super_role
  
  def index
    @markets = ProductMarket.paginate :include => [:image], :conditions => ["is_independent = ?", 0], 
                                      :per_page => 20, :page => params[:page], :order => "view_count desc"
  end

  def independent
    @markets = ProductMarket.paginate :include => [:image], :conditions => ["is_independent = ?", 1], 
                                      :per_page => 10, :page => params[:page], :order => "view_count desc"
    render :action => "index"
  end

  def show
    @market = ProductMarket.find(params[:id])
    @vendors = @market.vendors.paginate :per_page => 10, :page => params[:page]
    #@products = @market.products.paginate :per_page => 16, :page => params[:page]
    ProductMarket.update_all("view_count = #{@market.view_count + 1}",:id =>params[:id])
  end

  def new
    @market = ProductMarket.new
  end

  def create
    @market = ProductMarket.new(params[:market])
    if @market.save
      @image = ProductMarketImage.new(params[:image])
      @image.market = @market
      @image.save
      flash[:success] = "卖场创建成功！"
      redirect_to market_url(@market)
    else
      flash[:error] = "卖场创建失败！"
      rendor :action => "new"
    end
  end

  def edit
    @market = ProductMarket.find(params[:id])
  end

  def update
    @market = ProductMarket.find(params[:id])
    #params[:market][:category_ids] ||= []
    #params[:market][:brand_ids] ||= []
    if @market.update_attributes(params[:market])
      if params[:image]
        if @market.image
          @image = @market.image
          @image.update_attributes(params[:image])
        else
          @image = ProductMarketImage.new(params[:image])
          @image.market = @market
          @image.save
        end
      end
      flash[:success] = "市场更新成功！"
      redirect_to market_path(@market)
    end
  end

end
