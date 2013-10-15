class CommonController < ProductsController
  
  def index

  end
  
  def first_class_update
    return unless request.xhr?
    @category = ProductCategory.find(params[:first_class_id])
    second_class = @category.valid_children
    #@brands = @category.owned_brands
    render :update do |page|
      page << update_select_box( "product_category_id", second_class, {:text => :name_zh, :include_blank => true} )
      #page << update_select_box( "product_brand_id", @brands, {:text => :name_zh, :include_blank => false} )
      #page.replace_html "product_params", :partial => "products/params", :locals => {:category => @category}
    end
  end

  def first_class_update_for_category
    return unless request.xhr?
    @category = ProductCategory.find(params[:first_class_id])
    second_class = @category.valid_children
    render :update do |page|
      page << update_select_box( "category_id", second_class, {:text => :name_zh, :include_blank => true} )
      page.visual_effect(:highlight, "category_id", :duration => 0.5)
    end
  end

  def first_class_update_for_param
    return unless request.xhr?
    @category = ProductCategory.find(params[:first_class_id])
    second_class = @category.valid_children
    render :update do |page|
      page << update_select_box( "param_category_id", second_class, {:text => :name_zh, :include_blank => true} )
    end
  end

  def first_class_update_for_property
    return unless request.xhr?
    @category = ProductCategory.find(params[:first_class_id])
    second_class = @category.valid_children
    render :update do |page|
      page << update_select_box( "property_category_id", second_class, {:text => :name_zh, :include_blank => true} )
    end
  end

  def province_update_for_city
    return unless request.xhr?
    @province = City.find(params[:province_id])
    cities = @province.children
    render :update do |page|
      page << update_select_box( "city_id", cities, {:text => :name_zh, :include_blank => true} )
    end
  end

  def second_class_update
    return unless request.xhr?
    @category = ProductCategory.find(params[:second_class_id])
    #@brands = @category.owned_brands
    render :update do |page|
      #page << update_select_box( "product_brand_id", @brands, {:text => :name_zh, :include_blank => false} )
      page.replace_html "product_params", :partial => "products/params", :locals => {:category => @category}
      page.replace_html "product_properties", :partial => "products/properties", :locals => {:category => @category}
    end
  end

  def remove_product_image
    @image = ProductImage.find(params[:id])
    @product = @image.product
    @image.destroy
    render :update do |page|
      page.remove("image_#{@image.id}")
    end
  end

  def sync_brands_vendors
    @brand = ProductBrand.find(params[:id])
    @brand.valid_products.each do |product|
      exist_vendors = @brand.vendors
      new_vendor = product.vendor
      if new_vendor
        exist_vendors << new_vendor unless exist_vendors.include?(new_vendor)
      end
    end
    flash[:notice] = "同步成功！"
    redirect_to brand_url(@brand)
  end

  def sync_brands_categories
    @brand = ProductBrand.find(params[:id])
    @brand.valid_products.each do |product|
      exist_categories = @brand.categories
      new_category = product.category
      if new_category
        exist_categories << new_category unless exist_categories.include?(new_category)
      end
    end
    flash[:notice] = "同步成功！"
    redirect_to brand_url(@brand)
  end

  def sync_vendors_brands
    @vendor = ProductVendor.find(params[:id])
    @vendor.valid_products.each do |product|
      exist_brands = @vendor.brands
      new_brand = product.brand
      if new_brand
        exist_brands << new_brand unless exist_brands.include?(new_brand)
      end
    end
    flash[:notice] = "同步成功！"
    redirect_to vendor_url(@vendor)
  end

  def sync_vendors_categories
    @vendor = ProductVendor.find(params[:id])
    @vendor.valid_products.each do |product|
      exist_categories = @vendor.categories
      new_category = product.category
      if new_category
        exist_categories << new_category unless exist_categories.include?(new_category)
      end
    end
    flash[:notice] = "同步成功！"
    redirect_to vendor_url(@vendor)
  end

  def sync_category_brands_vendors
    @category = ProductCategory.find(params[:id])
    #unless @category.valid_children.any?
      @category.products.each do |product|
        exist_brands = @category.brands
        new_brand = product.brand
        if new_brand
          exist_brands << new_brand unless exist_brands.include?(new_brand)
        end
        exist_vendors = @category.vendors
        new_vendor = product.vendor
        if new_vendor
          exist_vendors << new_vendor unless exist_vendors.include?(new_vendor)
        end
      end
    #end
    flash[:notice] = "同步成功！"
    redirect_to category_url(@category)
  end

  def sync_categories_products_count
    ProductCategory.second_class.each do |m|
      m.update_attribute :products_count, m.valid_products.length
    end
    ProductCategory.first_class.each do |c|
      class_total = c.valid_children.inject(0) {|sum, n| n.products_count + sum}
      c.update_attribute :products_count, class_total
    end
    flash[:success] = "分类产品数量数据同步成功！"
    redirect_to "/common"
  end

  def sync_brands_products_count
    ProductBrand.find(:all).each do |m|
      m.update_attribute :products_count, m.valid_products.length
    end
    flash[:success] = "品牌产品数量数据同步成功！"
    redirect_to "/common"
  end

  def sync_vendors_products_count
    #ProductVendor.reset_column_information
    ProductVendor.find(:all).each do |m|
      m.update_attribute :products_count, m.valid_products.length
    end
    flash[:success] = "商家产品数量数据同步成功！"
    redirect_to "/common"
  end

  def category
    #@category = ProductCategory.find_by_tagid(params[:id]) || ProductCategory.find(params[:id])
    @categories = ProductCategory.first_class
  end

  def export
    
  end

  def export_products
    e = Excel::Workbook.new
    if params[:type] == "brand"
      begin
        brand = ProductBrand.find(params[:brand_id])
      rescue ActiveRecord::RecordNotFound
        "Not Found"
      else
        products = brand.products
        sheetname = brand.name_zh
      end
    else params[:type] == "vendor"
      begin
        vendor = ProductVendor.find(params[:vendor_id])
      rescue
        "Not Found"
      else
        products = vendor.products
        sheetname = vendor.name_zh
      end
    end
    
    unless products
      flash[:notice] = "没有找到产品！"
      redirect_to "/common/export"
    else
      array = Array.new
      products.each do |product|
        item = Hash.new
        item["编号"] = product.productid
        item["名称"] = product.name
        array << item
      end
      e.addWorksheetFromArrayOfHashes(sheetname, array)
      headers['Content-Type'] = "application/vnd.ms-excel"
      headers['Content-Disposition'] = "attachment; filename='#{sheetname}产品.xls'"
      headers['Cache-Control'] = ''
      render :text => e.build
    end
  end

  def export_brands
    e = Excel::Workbook.new
    brands = ProductBrand.find(:all)
    sheetname = "品牌列表"
    unless brands
      flash[:notice] = "没有找到品牌！"
      redirect_to "/common/export"
    else
      array = Array.new
      brands.each do |brand|
        item = Hash.new
        item["编号"] = brand.id
        item["名称"] = brand.name_zh
        item["产品数量"] = brand.products_count
        array << item
      end
      e.addWorksheetFromArrayOfHashes(sheetname, array)
      headers['Content-Type'] = "application/vnd.ms-excel"
      headers['Content-Disposition'] = "attachment; filename=品牌列表.xls"
      headers['Cache-Control'] = ''
      render :text => e.build
    end
  end

  def delete_category_related_cache
    #@category = ProductCategory.find_by_tagid(params[:id]) || ProductCategory.find(params[:id])
    PRODUCT_CACHE.delete("category_show_brands_#{params[:id]}")
    PRODUCT_CACHE.delete("products_show_category_products_rank_#{params[:id]}")
    PRODUCT_CACHE.delete("products_show_related_article_#{params[:id]}")
    PRODUCT_CACHE.delete("products_show_related_topics_#{params[:id]}")
    PRODUCT_CACHE.delete("products_show_related_products_#{params[:id]}")
    #flash[:success] = "已清除#{@category.name_zh}相关缓存！"
    render :update do |page|
      page.visual_effect :highlight, @category.dom_id
    end
  end

  def delete_topics_related_cache
    ProductCategory.second_class.each do |category|
      PRODUCT_CACHE.delete("products_show_related_topics_#{category.tagid}")
    end
    flash[:success] = "所有分类终端页话题相关缓存清理成功！"
    redirect_to "/common"
  end

  def delete_articles_related_cache
    ProductCategory.second_class.each do |category|
      PRODUCT_CACHE.delete("products_show_related_article_#{category.tagid}")
    end
    flash[:success] = "所有分类终端页文章相关缓存清理成功！"
    redirect_to "/common"
  end
end
