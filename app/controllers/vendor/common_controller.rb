class Vendor::CommonController < VendorController

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

  def second_class_update
    return unless request.xhr?
    @category = ProductCategory.find(params[:second_class_id])
    #@brands = @category.owned_brands
    render :update do |page|
      #page << update_select_box( "product_brand_id", @brands, {:text => :name_zh, :include_blank => false} )
      page.replace_html "product_params", :partial => "products/params", :locals => {:category => @category}
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

  def remove_promotion_image
    @image = ProductVendorPromotionImage.find(params[:id])
    @image.destroy
    render :update do |page|
      page.remove("image_#{@image.id}")
    end
  end

  def sync_brands_vendors
    @brand = ProductBrand.find(params[:id])
    @brand.products.each do |product|
      exist_vendors = @brand.vendors
      new_vendor = product.vendor
      if new_vendor
        exist_vendors << new_vendor unless exist_vendors.include?(new_vendor)
      end
      logger.info "88888888888888888888888888888888888888888888"
      logger.info @brand.vendors.size
    end
    redirect_to brand_url(@brand)
  end

  def sync_brands_categories
    @brand = ProductBrand.find(params[:id])
    @brand.products.each do |product|
      exist_categories = @brand.categories
      new_category = product.category
      if new_category
        exist_categories << new_category unless exist_categories.include?(new_category)
      end
      logger.info "88888888888888888888888888888888888888888888"
      logger.info @brand.categories.size
    end
    redirect_to brand_url(@brand)
  end

  def sync_vendors_brands
    @vendor = ProductVendor.find(params[:id])
    @vendor.products.each do |product|
      exist_brands = @vendor.brands
      new_brand = product.brand
      if new_brand
        exist_brands << new_brand unless exist_brands.include?(new_brand)
      end
      logger.info "88888888888888888888888888888888888888888888"
      logger.info @vendor.brands.size
    end
    redirect_to vendor_url(@vendor)
  end

  def sync_vendors_categories
    @vendor = ProductVendor.find(params[:id])
    @vendor.products.each do |product|
      exist_categories = @vendor.categories
      new_category = product.category
      if new_category
        exist_categories << new_category unless exist_categories.include?(new_category)
      end
      logger.info "88888888888888888888888888888888888888888888"
      logger.info @vendor.categories.size
    end
    redirect_to vendor_url(@vendor)
  end

end
