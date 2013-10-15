class Charge::VendorsController < ChargeController

  def index
    @vendors = ProductVendor.paginate :conditions => ["is_cooperation = ?", true], :page => params[:page], :per_page => 20, :order => "updated_at desc"
  end

  def edit
    @vendor = ProductVendor.find(params[:id])
  end

  def update
    @vendor = ProductVendor.find(params[:id])
    if @vendor.update_attributes(params[:vendor])
      flash[:success] = "商铺信息更新成功！"
      redirect_to charge_vendor_path(@vendor)
    else
      flash[:error] = "商铺信息更新失败！"
      render :action => "edit"
    end
  end

  def show
    @vendor = ProductVendor.find(params[:id])
  end
end
