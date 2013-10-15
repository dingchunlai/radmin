class Vendor::PromotionsController < VendorController

  def index
    @promotions = VendorPromotion.paginate :page => params[:page], :per_page => 15, :order => "created_at desc", :conditions => ["vendor_id = ?", @vendor.id]
  end

  def new
    @promotion = VendorPromotion.new
    @promotion.vendor_id = @vendor.id
  end

  def create
    @promotion = VendorPromotion.new(params[:promotion])
    if @promotion.save
      flash[:success] = "促销创建成功！"
      redirect_to vendor_promotion_url(@promotion)
    else
      flash[:error] = "促销创建失败！"
      render :action => "new"
    end
  end

  def show
    @promotion = VendorPromotion.find(params[:id])
  end

  def edit
    @promotion = VendorPromotion.find(params[:id])
  end
  
  def update
    @promotion = VendorPromotion.find(params[:id])
    if @promotion.update_attributes(params[:promotion])
      flash[:success] = "促销更新成功！"
      redirect_to vendor_promotion_url(@promotion)
    else
      flash[:error] = "促销更新失败！"
      render :action => "edit"
    end
  end

  def destroy
    @promotion = VendorPromotion.find(params[:id])
    @promotion.destroy
    redirect_to vendor_promotions_url
  end
end
