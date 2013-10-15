class VendorsController < ProductsController
  
  def index
    if params[:category_id]
      @category = ProductCategory.find_by_tagid(params[:category_id])
      @vendors = @category.owned_vendors.paginate :per_page => 20, :page => params[:page] if @category.owned_vendors
    elsif params[:type] == "cooperation"
      @vendors = ProductVendor.paginate :include => [:brands, :categories, :image, :market], :conditions => ["product_vendors.is_cooperation = ?", true], :per_page => 10, :page => params[:page], :order => "class_index desc"
    else
      @vendors = ProductVendor.paginate :include => [:brands, :categories, :image, :market], :per_page => 10, :page => params[:page], :order => "class_index desc"
    end
  end

  def show
    @vendor = ProductVendor.find(params[:id])
    @products = @vendor.products.paginate :include => [:brand, :vendor, :category], :per_page => 15, :page => params[:page],
                                          :conditions => ["products.is_delete = ?", false], :order => "products.created_at desc"
  end

  def new
    @vendor = ProductVendor.new
    if params[:market_id]
      @vendor.market_id = params[:market_id]
    end
  end

  def create
    @vendor = ProductVendor.new(params[:vendor])
    @vendor.companyid = ProductVendor.maximum('companyid') + 1
    if @vendor.save
      @image = ProductVendorImage.new(params[:image])
      @image.vendor = @vendor
      @image.save
      flash[:success] = "商家创建成功！"
      redirect_to vendor_url(@vendor)
    else
      flash[:error] = "商家创建失败！"
      render :action => "new"
    end
  end

  def edit
    #return false unless needvendor(params[:id].to_i)  #必须是会员登录状态
    @vendor = ProductVendor.find(params[:id])
    #@brands = ProductBrand.find(:all, :order => ("name_en asc"))
    @initials = ("a".."z")
    #@initials = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
  end

  def update
    @vendor = ProductVendor.find(params[:id])
    @vendor.companyid = ProductVendor.maximum('companyid') + 1 unless @vendor.companyid
    params[:vendor][:category_ids] ||= []
    params[:vendor][:brand_ids] ||= []
    if @vendor.update_attributes(params[:vendor])
      if params[:image]
        if @vendor.image
          @image = @vendor.image
          @image.update_attributes(params[:image])
        else
          @image = ProductVendorImage.new(params[:image])
          @image.vendor = @vendor
          @image.save
        end
      end
      flash[:success] = "商家更新成功！"
      redirect_to vendor_path(@vendor)
    else
      flash[:error] = "商家更新失败！"
      redirect_to edit_vendor_path(@vendor)
    end
  end

  def is_recommend
    @vendor = ProductVendor.find(params[:id])
    checked_value = params[:cvalue]
    if checked_value == "true"
      @vendor.update_attribute(:is_recommend, 1)
    else
      @vendor.update_attribute(:is_recommend, 0)
    end
    render :nothing => true
  end

  def is_precinct
    @vendor = ProductVendor.find(params[:id])
    checked_value = params[:cvalue]
    if checked_value == "true"
      @vendor.update_attribute(:is_precinct, true)
      render_string = "<strong>是</strong>"
    else
      @vendor.update_attribute(:is_precinct, false)
      render_string = "否"
    end
    render :update do |page|
      page.replace_html "is_precinct_#{@vendor.dom_id}", render_string
			page.visual_effect(:highlight, "is_precinct_#{@vendor.dom_id}")
		end
  end

  def setup
    @vendor = ProductVendor.find(params[:id])
  end

  def install
    @vendor = ProductVendor.find(params[:id])
    if @vendor.update_attributes(params[:vendor])
      if params[:vendor][:plain_password] != ""
        @vendor.password = md5(params[:vendor][:plain_password])
        @vendor.save
      end
      flash[:success] = "设置成功！"
      redirect_to vendor_url(@vendor)
    else
      flash[:notice] = "请先选择是否合作！"
      render :action => "setup"
    end
  end

#  def delete
#    @vendor = ProductVendor.find(params[:id])
#    @vendor.destroy
#  end
end

