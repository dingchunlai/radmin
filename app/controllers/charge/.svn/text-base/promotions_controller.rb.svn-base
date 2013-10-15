class Charge::PromotionsController < ChargeController

  def index
    @promotions = VendorPromotion.paginate :page => params[:page], :per_page => 15, :order => "created_at desc"
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
      flash[:notice] = "处理成功！"
      redirect_to charge_promotion_url(@promotion)
    else
      flash[:error] = "处理失败！"
      render :action => "edit"
    end
  end
end
