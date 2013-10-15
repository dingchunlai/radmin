class Vendor::VendorSearchController < VendorController

  def index
    @params_string = {}
    @conditions = []
    @params_string.merge!("type" => params[:type])
    @keywords = params[:keywords]
    @status = params[:status]
    @phone = params[:phone]
    if params[:created_at_from] && params[:created_at_to] && params[:created_at_from] != "" && params[:created_at_to] != ""
      @conditions << "(created_at >= '#{params[:created_at_from]}' AND created_at < '#{params[:created_at_to]}')"
      @params_string.merge!("created_at_from" => params[:created_at_from], "created_at_to" => params[:created_at_to])
    elsif params[:created_at_from] && params[:created_at_from] != ""
      @conditions << "created_at >= '#{params[:created_at_from]}'"
      @params_string.merge!("created_at_from" => params[:created_at_from])
    elsif params[:created_at_to] && params[:created_at_to] != ""
      @conditions << "created_at < '#{params[:created_at_to]}'"
      @params_string.merge!("created_at_to" => params[:created_at_to])
    end
    if params[:type] == "product"
      #@conditions << "vendor_id = '#{@vendor.id}'"
      if @status && @status != ""
        @conditions << "status = '#{@status}'"
        @params_string.merge!("status" => @status)
      end
      if @keywords && @keywords != ""
        @conditions << "(name LIKE '%#{@keywords}%' OR detail LIKE '%#{@keywords}%' OR tags LIKE '%#{@keywords}%')"
        @params_string.merge!("keywords"  => @keywords)
      end
      @products = Product.paginate :conditions => @conditions.join(" and "), :per_page => 20, :page => params[:page]
      @result = @products
    elsif params[:type] == "pricing"
      @conditions << "vendor_id = '#{@vendor.id}'"
      if @status && @status != ""
        @conditions << "state = '#{@status}'"
        @params_string.merge!("status" => @status)
      end
      if @keywords && @keywords != ""
        @conditions << "(name LIKE '%#{@keywords}%' OR xinghao LIKE '%#{@keywords}%' OR username LIKE '%#{@keywords}%' OR brand LIKE '%#{@keywords}%')"
        @params_string.merge!("keywords"  => @keywords)
      end
      if @phone && @phone != ""
        @conditions << "phone LIKE '%#{@phone}%'"
        @params_string.merge!("phone"  => @phone)
      end
      @pricings = ProductPricing.paginate :conditions => @conditions.join(" and "), :per_page => 20, :page => params[:page]
      @result = @pricings
    end
    logger.info "************************** #{request.post?} **************************"
#    render :layout => "/layouts/vendor", :template => "/vendor/search/index"
    redirect_to :action => "index", :params => @params_string if request.post?
  end
end
