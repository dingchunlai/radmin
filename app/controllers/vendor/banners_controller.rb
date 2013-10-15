class Vendor::BannersController < VendorController

  def index
    @banners = VendorBanner.paginate :page => params[:page], :per_page => 15, :order => "created_at desc", :conditions => ["vendor_id = ?", @vendor.id]
  end

  def show
    @banner = VendorBanner.find(params[:id])
  end

  def new
    @banner = VendorBanner.new
    @banner.vendor_id = @vendor.id
  end

  def create
    @banner = VendorBanner.new(params[:banner])
    if @banner.save
      flash[:success] = "横幅添加成功！"
      redirect_to vendor_banner_url(@banner)
    else
      flash[:error] = "横幅添加失败！"
      render :action => "new"
    end
  end

  def edit
    @banner = VendorBanner.find(params[:id])
  end

  def update
    @banner = VendorBanner.find(params[:id])
    if @banner.update_attributes(params[:banner])
      flash[:success] = "横幅更新成功！"
      redirect_to vendor_banner_url(@banner)
    else
      flash[:error] = "横幅更新失败!"
      render :action => "edit"
    end
  end

  def destroy
    @banner = VendorBanner.find(params[:id])
    @banner.destroy
    redirect_to vendor_banners_url
  end
end
