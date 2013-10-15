class DepositsController < ProductsController

  def index
    @vendor = ProductVendor.find(params[:vendor_id])
    @deposits = @vendor.deposits.find(:all, :order => "created_at desc")
  end

  def new
    @vendor = ProductVendor.find(params[:vendor_id])
    @deposit = VendorDeposit.new
  end

  def create
    @deposit = VendorDeposit.new(params[:deposit])
    if @deposit.save
      flash[:success] = "充值成功！"
      redirect_to vendor_deposits_url(:vendor_id => @deposit.vendor_id)
    else
      flash[:error] = "充值失败！"
      render :action => "new"
    end
  end
end
