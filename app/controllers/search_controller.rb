class SearchController < ProductsController
  
  def index
		@params_string = {}
		#@products = Product.query
		#@products.name_LIKE('%params[:keywords]%') if params[:keywords]
		#@products.find
		@params_string.merge!("type" => params[:type])
		@keywords = params[:keywords]
		@created_at_from = params[:created_at_from]
		@created_at_to = params[:created_at_to]
		@updated_at_from = params[:updated_at_from]
		@updated_at_to = params[:updated_at_to]
		@status = params[:status]
		@brand_id = params[:brand_id]
		@conditions = []
		@params_string.merge!("keywords"  => params[:keywords]) unless params[:keywords] == ""
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
    if params[:updated_at_from] && params[:updated_at_to] && params[:updated_at_from] != "" && params[:updated_at_to] != ""
      @conditions << "(updated_at >= '#{params[:updated_at_from]}' AND updated_at < '#{params[:updated_at_to]}')"
      @params_string.merge!("updated_at_from" => params[:updated_at_from], "updated_at_to" => params[:updated_at_to])
    elsif params[:updated_at_from] && params[:updated_at_from] != ""
      @conditions << "updated_at >= '#{params[:updated_at_from]}'"
      @params_string.merge!("updated_at_from" => params[:updated_at_from])
    elsif params[:updated_at_to] && params[:updated_at_to] != ""
      @conditions << "updated_at < '#{params[:updated_at_to]}'"
      @params_string.merge!("updated_at_to" => params[:updated_at_to])
    end
		if params[:status]
    @conditions << "status = '#{params[:status]}'" unless params[:status] == ""
		@params_string.merge!("status" => params[:status]) unless params[:status] == ""
    end
    @brand = nil
	#add sueg
      if !@brand_id.nil?
        @brand = ProductBrand.find(@brand_id)
        @conditions << "brand_id = #{@brand.id}"
        @params_string.merge!("brand_id" => @brand.id)
      end
    #end		
    if params[:type] == "product"
		  if params[:category_parent_id] || (params[:product] && params[:product][:category_parent_id] != "" && params[:category_id] == "")
        cs = ProductCategory.find(params[:category_parent_id] || params[:product][:category_parent_id]).valid_children
        @conditions << "category_id in (#{cs.collect{|c| c.id}.join(',')})"
        @params_string.merge!("category_parent_id" => (params[:category_parent_id] || params[:product][:category_parent_id]))
        @category_parent_id = (params[:category_parent_id] || params[:product][:category_parent_id])
      elsif params[:category_id] && params[:category_id] != ""
        @conditions << "category_id = '#{params[:category_id]}'"
        @params_string.merge!("category_id" => params[:category_id])
      end
      @conditions << "is_delete = 0"
      @conditions << "source = 1" if params[:source] == "zxj"
      @params_string.merge!("source" => "zxj") if params[:source] == "zxj"
      @conditions << "(name LIKE '%#{params[:keywords]}%' OR detail LIKE '%#{params[:keywords]}%' OR tags LIKE '%#{params[:keywords]}%')" if (params[:keywords] && params[:keywords] != "")
			@products = Product.paginate :conditions => @conditions.join(" and "), :per_page => 20, :page => params[:page]
      @result = @products
      redirect_to :action => "index", :params => @params_string if request.post?
		elsif params[:type] == "vendor"
			@conditions << "name_zh LIKE '%#{params[:keywords]}%'" if (params[:keywords] && params[:keywords] != "")
			@vendors = ProductVendor.paginate :conditions => @conditions.join(" and "), :per_page => 20, :page => params[:page]
      @result = @vendors
      redirect_to :action => "index", :params => @params_string if request.post?
		elsif params[:type] == "brand"
			@conditions << "name_zh LIKE '%#{params[:keywords]}%'" if (params[:keywords] && params[:keywords] != "")
			@brands = ProductBrand.paginate :conditions => @conditions.join(" and "), :per_page => 20, :page => params[:page]
      @result = @brands
      redirect_to :action => "index", :params => @params_string if request.post?
		elsif params[:type] == "vendor_products"
			@conditions << "(name LIKE '%#{params[:keywords]}%' OR detail LIKE '%#{params[:keywords]}%' OR tags LIKE '%#{params[:keywords]}%')" if (params[:keywords] && params[:keywords] != "")
			@conditions << "category_id = '#{params[:category_id] || params[:product][:category_id]}'" if (params[:category_id] || params[:product] && params[:product][:category_id] != "")
			@conditions << "vendor_id = '#{params[:vendor_id]}'"
      @params_string.merge!("category_id" => params[:category_id] || params[:product][:category_id]) if (params[:category_id] || params[:product] && params[:product][:category_id] != "")
      @params_string.merge!("vendor_id" => params[:vendor_id])
			@vendor = ProductVendor.find(params[:vendor_id]) if params[:vendor_id]
      @products = Product.paginate :conditions => @conditions.join(" and "), :per_page => 20, :page => params[:page]
      @result = @products
      redirect_to :action => "index", :params => @params_string if request.post?
		end
  end

end
