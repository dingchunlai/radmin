class QuotesController < ProductsController

  def index
    if params[:product_id]
      @product = Product.find(params[:product_id])
      @quotes = @product.quotes.paginate :per_page => 20, :page => params[:page]
    elsif params[:vendor_id]
      @vendor = ProductVendor.find(params[:vendor_id])
      @quotes = @vendor.quotes.paginate :per_page => 20, :page => params[:page]
    else
      @quotes = ProductQuotes.paginate :per_page => 20, :page => params[:page]
    end
  end

  def show
    @quote = ProductQuote.find(params[:id])
    @product = @quote.product
    @vendor = @quote.vendor
  end
end
