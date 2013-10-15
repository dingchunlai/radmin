class Charge::ProductsController < ChargeController

  def index
    
  end

  def show
    @product = Product.find_by_productid(params[:id])
  end
  
end
