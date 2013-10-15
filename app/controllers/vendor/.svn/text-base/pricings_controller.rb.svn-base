class Vendor::PricingsController < VendorController

  def index
    @pricings = @vendor.pricings.paginate :per_page => 20, :page => params[:page], :order => "createtime desc"
  end

  def edit
    @pricing = ProductPricing.find(params[:id])
  end

  def update
    @pricing = ProductPricing.find(params[:id])
    if @pricing.update_attributes(params[:pricings])
      flash[:success] = "更新成功！"
      redirect_to vendor_pricings_url
    else
      flash[:error] = "更新失败！"
      render :action => "edit"
    end
  end
end
