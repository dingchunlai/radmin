class Vendor::HonorsController < VendorController

  def index
    @honors = VendorHonor.paginate :page => params[:page], :per_page => 15, :order => "created_at desc", :conditions => ["vendor_id = ?", @vendor.id]
  end

  def show
    @honor = VendorHonor.find(params[:id])
  end

  def new
    @honor = VendorHonor.new
    @honor.vendor_id = @vendor.id
  end

  def create
    @honor = VendorHonor.new(params[:honor])
    if @honor.save
      flash[:success] = "荣誉添加成功！"
      redirect_to vendor_honor_url(@honor)
    else
      flash[:error] = "荣誉添加失败！"
      render :action => "new"
    end
  end

  def edit
    @honor = VendorHonor.find(params[:id])
  end

  def update
    @honor = VendorHonor.find(params[:id])
    if @honor.update_attributes(params[:honor])
      flash[:success] = "荣誉更新成功！"
      redirect_to vendor_honor_url(@honor)
    else
      flash[:error] = "荣誉更新失败!"
      render :action => "edit"
    end
  end

  def destroy
    @honor = VendorHonor.find(params[:id])
    @honor.destroy
    redirect_to vendor_honors_url
  end
end
