class VendorPointsController < ProductsController
  def index
    if params[:vendor_id]
      @vendor = ProductVendor.find(params[:vendor_id])
      @vendor_points = @vendor.vendor_points.paginate :page => params[:page], :order => "created_at desc",
        :conditions => "deleted_at is null"
    else
      @vendor_points = VendorPoint.paginate :page => params[:page], :order => "created_at desc",
        :conditions => "deleted_at is null"
    end
  end

  def new
    if params[:vendor_id]
      @vendor = ProductVendor.find(params[:vendor_id])
      @vendor_point = VendorPoint.new
      @vendor_point.vendor_id = params[:vendor_id]
    end
  end

  def create
    @vendor_point = VendorPoint.new(params[:vendor_point])
    if @vendor_point.save && @vendor_point.vendor.increment!(:comments_count)
      flash[:success] = "评论创建成功！"
      redirect_to vendor_points_url
    else
      flash[:error] = "评论创建失败！"
      render new_vendor_point_url
    end
  end

  def edit
    @vendor_point = VendorPoint.find(params[:id])
    @vendor = @vendor_point.vendor
  end

  def update
    @vendor_point = VendorPoint.find(params[:id])
    if @vendor_point.update_attributes(params[:vendor_point])
      flash[:success] = "评论更新成功！"
      redirect_to vendor_points_url
    else
      flash[:error] = "评论更新失败！"
      render new_vendor_point_url
    end
  end

  def destroy
    @vendor_point = VendorPoint.find(params[:id])
    @vendor_point.deleted_at = Time.now
    @vendor_point.save
    @vendor_point.vendor.decrement!(:comments_count)
    render :update do |page|
      page.visual_effect :highlight, @vendor_point.dom_id
      page.remove @vendor_point.dom_id
    end
  end

  def operate
    if params[:destroy_all] && params[:comment_ids]
      VendorPoint.update_all(["deleted_at = ?", Time.now], :id => params[:comment_ids])
      params[:comment_ids].each do |id|
        VendorPoint.find(id).vendor.decrement!(:comments_count)
      end
      flash[:notice] = "选中评论已经删除！"
    end
    redirect_to request.referer
  end
end
