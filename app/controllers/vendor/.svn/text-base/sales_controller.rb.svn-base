class Vendor::SalesController < VendorController

  def index
    @sales = VendorSale.paginate :page => params[:page], :per_page => 15, :order => "created_at desc", :conditions => ["vendor_id = ?", @vendor.id]
  end

  def show
    @sale = VendorSale.find(params[:id])
  end

  def new
    @sale = VendorSale.new
    @sale.vendor_id = @vendor.id
  end

  def create
    @sale = VendorSale.new(params[:sale])
    if @sale.save
      flash[:success] = "热卖添加成功！"
      redirect_to vendor_sale_url(@sale)
    else
      flash[:error] = "热卖添加失败！"
      render :action => "new"
    end
  end

  def edit
    @sale = VendorSale.find(params[:id])
  end

  def update
    @sale = VendorSale.find(params[:id])
    if @sale.update_attributes(params[:sale])
      flash[:success] = "热卖更新成功！"
      redirect_to vendor_sale_url(@sale)
    else
      flash[:error] = "热卖更新失败!"
      render :action => "edit"
    end
  end

  def destroy
    @sale = VendorSale.find(params[:id])
    @sale.destroy
    redirect_to vendor_sales_url
  end
end
