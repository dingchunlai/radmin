class Vendor::QuotesController < VendorController

  def index
    @quotes = @vendor.quotes.paginate :per_page => 20, :page => params[:page]
  end

  def show
    @quote = ProductQuote.find(params[:id])
    @product = @quote.product
  end

  def new
    @quote = ProductQuote.new
    #@product = Product.find(params[:id])
    if params[:id]
      @quote.product_id = params[:id]
      @quote.vendor_id = @vendor.id
    else
      flash[:notice] = "请选择希望报价的产品！"
      redirect_to :back
    end
  end

  def create
    @quote = ProductQuote.new(params[:quote])
    if @quote.save
      flash[:success] = "报价创建成功！"
      redirect_to vendor_quote_url(@quote)
    else
      flash[:error] = "报价创建失败！"
      render :action => "new"
    end
  end

  def edit
    @quote = ProductQuote.find(params[:id])
  end

  def update
    @quote = ProductQuote.find(params[:id])
    if @quote.update_attributes(params[:quote])
      flash[:success] = "报价更新成功！"
      redirect_to vendor_quote_url(@quote)
    else
      flash[:error] = "报价更新失败！"
      render :action => "edit"
    end
  end

end
