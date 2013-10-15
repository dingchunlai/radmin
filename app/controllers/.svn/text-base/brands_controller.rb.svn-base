class BrandsController < ProductsController

  in_place_edit_for :brand, :truth_standard
  in_place_edit_for :brand, :editor_point

  def index
    if params[:category_id]
      @category = ProductCategory.find_by_tagid(params[:category_id])
      @brands = @category.owned_brands.paginate :per_page => 20, :page => params[:page] if @category.owned_brands      
    else
      @brands = ProductBrand.paginate :per_page => 20, :page => params[:page]
    end
  end

  def show
    @brand_id = params[:id]
    @brand = ProductBrand.find(@brand_id)
    @products = @brand.products.paginate :include => [:brand, :vendor, :category], :per_page => 15, :page => params[:page],
                                         :conditions => ["products.is_delete = ?", false], :order => "products.created_at desc"
  #  ProductBrand.update_all (" view_count = #{@brand.view_count+1} " , :id=> @brand_id )
  end

  def new
    @brand = ProductBrand.new
  end

  def create
    @brand = ProductBrand.new(params[:brand])
    if @brand.save
      @image = ProductBrandImage.new(params[:image])
      @image.brand = @brand
      @image.save
      flash[:success] = "品牌创建成功！"
      redirect_to brand_url(@brand)
    else
      flash[:error] = "品牌创建失败！"
      rendor :action => "new"
    end
  end

  def edit
    @brand = ProductBrand.find(params[:id]) 
  end

  def update
    @brand = ProductBrand.find(params[:id])
    params[:brand][:category_ids] ||= []
    if @brand.update_attributes(params[:brand])
      if params[:image]
        if @brand.image
          @image = @brand.image
          @image.update_attributes(params[:image])
        else
          @image = ProductBrandImage.new(params[:image])
          @image.brand = @brand
          @image.save
        end
      end
      flash[:success] = "品牌更新成功！"
      redirect_to brand_path(@brand)
    end
  end

  def precinct
    @brands = ProductBrand.paginate :per_page => 20, :page => params[:page],
      :conditions => "id in (#{BRANDS_ID})"
  end

  def move
    if ["move_lower", "move_higher", "move_to_top", "move_to_bottom"].include?(params[:method]) and params[:id] =~ /^\d+$/
      ProductBrand.find(params[:id]).send(params[:method])
    end
    redirect_to :action => :index
  end

  def cooperation
    @brands = ProductBrand.paginate :conditions => ["is_cooperation = ?", true], :per_page => 20, :page => params[:page]
    render :action => "index"
  end

  def noncooperation
    @brands = ProductBrand.paginate :conditions => ["is_cooperation = ?", false], :per_page => 20, :page => params[:page]
    render :action => "index"
  end

  def hidden
    @brands = ProductBrand.paginate :conditions => ["is_hidden = ?", true], :per_page => 20, :page => params[:page]
    render :action => "index"
  end

  def nonhidden
    @brands = ProductBrand.paginate :conditions => ["is_hidden = ?", false], :per_page => 20, :page => params[:page]
    render :action => "index"
  end

  def recommend
    @brands = ProductBrand.paginate :conditions => ["is_recommend = ?", true], :per_page => 20, :page => params[:page]
    render :action => "index"
  end

  def is_cooperation
    @brand = ProductBrand.find(params[:id])
    checked_value = params[:cvalue]
    if checked_value == "true"
			@brand.update_attribute(:is_cooperation, 1)
			render_string = "<strong>合作</strong>"
		else
			@brand.update_attribute(:is_cooperation, 0)
			render_string = "普通"
		end
    render :update do |page|
			page.replace_html "cooperation_#{@brand.dom_id}", render_string
		end
  end

  def is_hidden
    @brand = ProductBrand.find(params[:id])
    checked_value = params[:cvalue]
    if checked_value == "true"
			@brand.update_attribute(:is_hidden, 1)
			render_string = "<strong>隐藏</strong>"
		else
			@brand.update_attribute(:is_hidden, 0)
			render_string = "显示"
		end
    render :update do |page|
			page.replace_html "hidden_#{@brand.dom_id}", render_string
		end
  end

  def is_recommend
    @brand = ProductBrand.find(params[:id])
    checked_value = params[:cvalue]
    if checked_value == "true"
			@brand.update_attribute(:is_recommend, 1)
			render_string = "<strong>推荐</strong>"
		else
			@brand.update_attribute(:is_recommend, 0)
			render_string = "普通"
		end
    render :update do |page|
			page.replace_html "recommend_#{@brand.dom_id}", render_string
		end
  end

  def setup
    @brand = ProductBrand.find(params[:id])
  end

  def install
    @brand = ProductBrand.find(params[:id])
    if @brand.update_attributes(params[:brand])
      flash[:success] = "指数更新成功！"
      redirect_to setup_brand_url(@brand)
    else
      flash[:error] = "指数更新失败！"
      render :action => "setup"
    end
  end
  
  def update_product
    p = Product.find(params[:id])
    puts "==================="
    puts params[:id]
    puts params[:brand_id]
    puts "==============="
    brand_id = params[:brand_id]
    p.update_attribute(:brand_id,brand_id)
     rt = alert("保存成功")
     render :text => rt
  end
end
