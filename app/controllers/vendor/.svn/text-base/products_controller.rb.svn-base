class Vendor::ProductsController < VendorController

  def index
    @products = @vendor.products.paginate :include => [:brand, :vendor, :category], :page => params[:page], :per_page => 18, :order => "products.created_at desc", :conditions => ["products.is_delete = ?", false]
  end

  def show
    @product = Product.find_by_productid(params[:id])
  end

  def new
    @product = Product.new
    1.times { @product.images.build }
    if params[:vendor_id]
      @product.vendor_id = params[:vendor_id]
    elsif params[:brand_id]
      @product.brand_id = params[:brand_id]
    elsif params[:category_id]
      @product.category_id = params[:category_id]
    end
  end

  def create
    @product = Product.new(params[:product])
    @product.productid = Product.maximum('productid') + 1
    @product.now_price = 888888 if params[:product][:now_price].to_i == 0
    @product.special_price = 888888 if params[:product][:special_price].to_i == 0
    if @product.save
      @image = ProductImage.new
      params[:attachment_data] ||= []
      params[:attachment_data].each do |file|
        @image = ProductImage.create({:uploaded_data => file}) unless file == ""
        @image.is_primary = @product.images.empty?
        @image.product = @product
        @image.save
        @product.reload
      end
      flash[:success] = "产品创建成功！"
      redirect_to vendor_product_url(:id => @product.productid)
    else
      flash[:error] = "产品创建失败！"
      render :action => "new"
    end
  end

  def edit
    @product = Product.find(:first, :conditions => ["productid = ?", params[:id]])
    @product.now_price = 0.0 if @product.now_price == 888888
    @product.special_price = 0.0 if @product.special_price == 888888
    @category = @product.category
    @product.category_parent_id = @category ? @category.parent_id : nil
  end

  def update
    @product = Product.find(:first, :conditions => ["productid = ?", params[:id]])
    params[:product][:existing_param_attributes] ||= {}
    @product.productid = Product.maximum('productid') + 1 unless @product.productid
    params[:product][:now_price] = 888888 if params[:product][:now_price].to_i == 0
    params[:product][:special_price] = 888888 if params[:product][:special_price].to_i == 0
    if @product.update_attributes(params[:product])
      @image = ProductImage.new
      params[:attachment_data] ||= []
      params[:attachment_data].each do |file|
        @image = ProductImage.create({:uploaded_data => file}) unless file == ""
        @image.is_primary = @product.images.empty?
        @image.product = @product
        @image.save
      end
      if params[:primary_image]
        @primary_image = ProductImage.find(params[:primary_image])
        unless @primary_image.is_primary
          @product.images.each {|img| img.update_attribute(:is_primary, 0)}
          @primary_image.update_attribute(:is_primary, 1)
        end
      end
      if params[:apply_up]
        @product.update_attribute(:status, 3)
        flash[:success] = "产品状态更新为待上架！"
      elsif params[:apply_down]
        @product.update_attribute(:status, 5)
        flash[:success] = "产品状态更新为待下架！"
      else
        flash[:success] = "产品更新成功！"
      end
      redirect_to vendor_product_url(:id => @product.productid)
    else
      flash[:error] = "有错误，请仔细检查所填项目！"
      render :action => "edit"
    end
  end

  def destroy
    @product = Product.find(params[:id])
    @product.destroy
    render :update do |page|
      page.visual_effect :highlight, @product.dom_id, :duration => 5
      page.remove @product.dom_id
    end
  end

  def is_sale
    @product = Product.find(params[:id])
    checked_value = params[:cvalue]
    if checked_value == "true"
      @product.update_attribute(:is_sale, 1)
    else
      @product.update_attribute(:is_sale, 0)
    end
    render :nothing => true
  end

  def is_recommend
    @product = Product.find(params[:id])
    checked_value = params[:cvalue]
    if checked_value == "true"
      @product.update_attribute(:is_recommend, 1)
    else
      @product.update_attribute(:is_recommend, 0)
    end
    render :nothing => true
  end

  def is_delete
    @product = Product.find(params[:id])
    @product.is_delete ? @product.update_attribute(:is_delete, 0) : @product.update_attribute(:is_delete, 1)
#    link_text = @product.is_delete ? "恢复" : "删除"
    render :update do |page|
      page.visual_effect :highlight, @product.dom_id, :duration => 5
      page.remove @product.dom_id
#      page.replace_html @product.dom_id("delete"), link_text
#      page.visual_effect :highlight, @product.dom_id("delete")
    end
#    checked_value = params[:cvalue]
#    if checked_value == "true"
#      @product.update_attribute(:is_delete, 1)
#    else
#      @product.update_attribute(:is_delete, 0)
#    end
#    render :nothing => true
  end

  def operate
    #return false unless check_administrator_role
    if params[:do_up]
      Product.update_all(["status = ?", 1], "id in (#{params[:product_ids].join(',')}) and (status = 2 or status = 3)")
      #Product.update_all(["status = ?", 1], :id => params[:product_ids], :status => 2)
      flash[:success] = "选中产品状态成功从“已审核或待上架”更新为“已上架”！"
    elsif params[:do_down]
      Product.update_all(["status = ?", 4], "id in (#{params[:product_ids].join(',')}) and (status = 1 or status = 5)")
      #Product.update_all(["status = ?", 4], :id => params[:product_ids], :status => 5)
      flash[:success] = "选中产品状态成功从“已上架或待下架”更新为“已下架”！"
    elsif params[:apply_up]
      Product.update_all(["status = ?", 3], :id => params[:product_ids], :status => 2)
      flash[:success] = "选中产品状态成功从“已审核”更新为“待上架”！"
    elsif params[:apply_down]
      Product.update_all(["status = ?", 5], :id => params[:product_ids], :status => 1)
      flash[:success] = "选中产品状态成功从“已上架”更新为“待下架”！"
    end
    redirect_to request.referer
  end

  def update_status
    @product = Product.find(params[:id])
    @product.update_attribute(:status, 2)
    render :update do |page|
      page.visual_effect :highlight, @product.dom_id
      page.replace_html @product.dom_id("status"), product_status(@product.status)
    end
  end

  def auto_complete_belongs_to_for_product_brand_name_zh
    @brands = ProductBrand.find(
      :all,
      :conditions => ['LOWER(name_zh) LIKE ?', "%#{params[:brand][:name_zh]}%"],
      :limit => 10
    )
    render :inline => '<%= model_auto_completer_result(@brands, :name_zh) %>'
  end
  
end
