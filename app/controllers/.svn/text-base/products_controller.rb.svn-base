class ProductsController < ApplicationController
  layout "product"
  helper :products
  
  before_filter :check_product_administrator_role
  
  auto_complete_for :brand, :name_zh, :limit => 15
  in_place_edit_for :product, :model
  in_place_edit_for :product, :unit
  in_place_edit_for :product, :now_price
  in_place_edit_for :product, :name

  uses_tiny_mce :options => {
                              :language => 'zh',
                              :theme => 'advanced',
                              :width => "760px",
                              :convert_urls => false,
                              :relative_urls => false,
                              :visual => false,
                              :theme_advanced_buttons1 => "bold,italic,underline,strikethrough,|,justifyleft,justifycenter,justifyright,justifyfull,|,bullist,numlist,|,formatselect,fontselect,fontsizeselect,|,outdent,indent,blockquote,|,undo,redo",
                              :theme_advanced_buttons2 => "tablecontrols,|,hr,removeformat,visualaid,code |,hr,removeformat,visualaid,|,link,unlink,anchor,image,upload,cleanup,|,forecolor,backcolor,code",
                              :theme_advanced_buttons3 => "",
                              :theme_advanced_resizing => true,
                              :theme_advanced_resize_horizontal => false,
                              :theme_advanced_toolbar_location => "top",
                              :theme_advanced_toolbar_align => "left",
                              :theme_advanced_statusbar_location => "bottom",
                              :plugins => %w{ table fullscreen upload}
                            },
                  :only => [:new, :create, :edit, :update]

#  def index
#    @products = Product.paginate :include => [:brand, :vendor, :params, :category], :page => params[:page], :per_page => 18
#  end
  
  def index
    # Set instance variables for our view...if selected then highlight
    @category = params[:category].blank? ? ProductCategory.find(1) : ProductCategory.find(params[:category])
    @brand = params[:brand].blank? ? "%" : ProductBrand.find(params[:brand])
    @price = params[:price].blank? ? "%" : params[:price]
    @alpha = params[:alpha].blank? ? "%" : params[:alpha]
    @query = params[:query].blank? ? "" : params[:query]
    @vendor_direct_products = (@category.id == 1 ? Product.direct_products[0, 2] : @category.vendor_direct_products[0, 2])
    @brands = (@category.id == 1 ? ProductBrand.valid[0, 10] : @category.owned_brands)

    @sort = params[:sort].blank? ? "%" : params[:sort]

    # If we're filtering category include it in the find
    includes = params[:category] ? [:product_category] : nil

    # build an array of conditions
    if params[:brand] || params[:category] || params[:price] || params[:type] || params[:query]
      @conditions = []
      @conditions << "products.is_delete = false"
      if params[:category] && @category.valid_children.any?
        cs = @category.valid_children.collect{|c| c.id}.join(",")
        @con1 = params[:category] ? (@conditions << "products.category_id in (#{cs})") : nil
      else
        @con1 = params[:category] ? (@conditions << "products.category_id = '#{params[:category]}'") : nil
      end
      @con2 = params[:brand] ? (@conditions << "products.brand_id = '#{params[:brand]}'") : nil
      #Filter by price range
      if params[:price] && (params[:price].include? "+")
        @con3 = params[:price] ? (@conditions << "products.now_price > #{params[:price].split('>')[0].to_i}") : nil
      else
        @con3 = params[:price] ? (@conditions << "products.now_price between #{params[:price].split('-')[0].to_i} and #{params[:price].split('-')[1].to_i}") : nil
      end
      #Filter by type
      @con4 = params[:type] ? (@conditions << "products.typehood = #{params[:type]}") : nil
      @con5 = params[:query] ? (@conditions << "name LIKE '%#{@query}%'") : nil
    end

    if params[:order]
      case params[:order]
        when "sortdesc"
          @order = "products.now_price desc"
        when "sortasc"
          @order = "products.now_price asc"
        when "new"
          @order = "products.id desc"
        when "class"
          #@include = [:vendor]
          @order = "product_vendors.class_index desc"
        when "awareness"
          #@include = [:vendor]
          @order = "product_vendors.brand_awareness desc"
        when "faith"
          #@include = [:vendor]
          @order = "product_vendors.price_faith desc"
        when "praise"
          @order = "products.public_praise desc"
        when "active"
          @order = "products.liveness desc"
      end
    else
      @order = "products.public_praise desc"
    end

    # count the number of records returned with includes and conditions set
    #@company_count = Company.count(:include => includes, :conditions => @conditions.join(" and "))

    # Finally, our find
    if @conditions
      @products = Product.paginate :include => [:images, :vendor], :page => params[:page], :per_page => 18, :conditions => @conditions.join(" and "), :order => @order
    #elsif @order && @include
    #  @products = Product.paginate :include => [:images, :vendor], :page => params[:page], :per_page => 18, :order => @order
    else
      @products = Product.paginate :include => [:brand, :vendor, :params, :category], :page => params[:page], :per_page => 18, :order => @order, :conditions => ["products.is_delete = ?", false]
    end

    respond_to do |format|
      format.html
      format.xml  { render :xml => @products }
    end
  end

  def zxj
    @products = Product.paginate :include => [:brand, :vendor, :params, :category], :page => params[:page], :per_page => 18,
                                 :order => @order, :conditions => ["products.source = ? and products.is_delete = ?", 1, false]
    render :action => "index"
  end

  def special
    @products = Product.paginate :include => [:brand, :vendor, :params, :category], :page => params[:page], :per_page => 18,
                                 :order => "products.updated_at desc", :conditions => ["products.special_price <> ? and products.is_delete = ?", 888888, false]
    render :action => "index"
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
      PRODUCT_CACHE.delete("categories_show_products_#{@product.category.tagid}_") if @product.category
      PRODUCT_CACHE.delete("categories_show_products_#{@product.category.tagfatherid}_") if @product.category
      redirect_to product_url(:id => @product.productid)
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
      if params[:audit]
        @product.update_attribute(:status, 2)
        flash[:success] = "产品状态更新为已审核！"
      else
        flash[:success] = "产品更新成功！"
      end
      PRODUCT_CACHE.delete("categories_show_products_#{@product.category.tagid}_") if @product.category
      PRODUCT_CACHE.delete("categories_show_products_#{@product.category.tagfatherid}_") if @product.category
      redirect_to product_url(:id => @product.productid)
    else
      flash[:error] = "有错误，请仔细检查所填项目！"
      render :action => "edit"
    end
  end

  def destroy
    @product = Product.find(params[:id])
    #@product.destroy
  end

  def preview
    @product = Product.new(params[:product])
    @vendor = @product.vendor || ProductVendor.find(1)
    @category = @product.category || ProductCategory.find(13)
    @pparams = @product.params
    render :layout => false
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
  
  def is_precinct
    @product = Product.find(params[:id])
    checked_value = params[:cvalue]
    if checked_value == "true"
      @product.update_attribute(:is_precinct, true)
      render_string = "<strong>是</strong>"
    else
      @product.update_attribute(:is_precinct, false)
      render_string = "否"
    end
    render :update do |page|
      page.replace_html "is_precinct_#{@product.dom_id}", render_string
			page.visual_effect(:highlight, "is_precinct_#{@product.dom_id}")
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

  def is_delete
    @product = Product.find(params[:id])
    @product.is_delete ? @product.update_attribute(:is_delete, 0) : @product.update_attribute(:is_delete, 1)
    link_text = @product.is_delete ? "恢复" : "删除"
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
      :conditions => ['LOWER(name_zh) LIKE ? AND is_hidden = ?', "%#{params[:brand][:name_zh]}%", false],
      :limit => 10
    )
    render :inline => '<%= model_auto_completer_result(@brands, :name_zh) %>'
  end

  def check_product_administrator_role
    if staff_logged_in?
      unless current_staff.roles.detect { |role| role == "产品管理" || role == "管理员" }
        flash[:notice] = "对不起，你没有管理产品的权限！"
        redirect_to "/user/login"
      end
    else
      flash[:notice] = "对不起，请登录！"
      redirect_to "/user/login"
    end
  end

  def check_editor_role
    check_role("产品编辑")
  end

  def check_role(role)
    unless current_staff.roles.include?(role)
      flash[:notice] = "对不起，你没有权限操作！"
      redirect_to "/vendors"
    end
  end

  def check_product_super_role
    unless current_staff.roles.detect { |role| role == "产品组长" || role == "管理员" }
      flash[:notice] = "对不起，你没有产品组长的权限！"
    end
  end
  
end
