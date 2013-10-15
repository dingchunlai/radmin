class CategoriesController < ProductsController
  before_filter :check_product_super_role
  
  def index
    @categories = ProductCategory.find(:all, :conditions => ["parent_id = ?", 1], :order => "is_valid, position")
  end

  def new
    @category = ProductCategory.new
    @category.parent_id = params[:id] if params[:id]
  end

  def create
    @category = ProductCategory.new(params[:category])
    if @category.save
      PRODUCT_CACHE.delete("category_show_brands_#{@category.tagid}")
      flash[:success] = "类别创建成功！"
      redirect_to category_url(@category.tagid)
    else
      flash[:error] = "类别创建失败！"
      render :action => "new"
    end
  end

  def show
    @category = ProductCategory.find_by_tagid(params[:id]) || ProductCategory.find(params[:id])
    @products = @category.owned_products.paginate :include => [:brand, :vendor, :category], :per_page => 15, :page => params[:page], :order => "products.created_at desc" unless @category.valid_children.any?
  end

  def edit
    @category = ProductCategory.find_by_tagid(params[:id]) || ProductCategory.find(params[:id])
  end

  def update
    @category = ProductCategory.find_by_tagid(params[:id]) || ProductCategory.find(params[:id])
    if @category.update_attributes(params[:category])
      flash[:success] = "分类更新成功！"
      redirect_to category_path(@category.tagid)
    else
      flash[:error] = "分类更新失败！"
      render :action => "edit"
    end
  end

  def move
    if ["move_lower", "move_higher", "move_to_top", "move_to_bottom"].include?(params[:method]) and params[:id] =~ /^\d+$/
      ProductCategory.find(params[:id]).send(params[:method])
    end
    redirect_to :action => :index
  end

  def is_valid
    @category = ProductCategory.find(params[:id])
    checked_value = params[:cvalue]
    if checked_value == "true"
      @category.update_attribute(:is_valid, 1)
    else
      @category.update_attribute(:is_valid, 0)
    end
    render :nothing => true
  end

  def is_precinct
    @category = ProductCategory.find(params[:id])
    checked_value = params[:cvalue]
    if checked_value == "true"
      @category.update_attribute(:is_precinct, true)
      render_string = "<strong>是</strong>"
    else
      @category.update_attribute(:is_precinct, false)
      render_string = "否"
    end
    render :update do |page|
      page.replace_html "is_precinct_#{@category.dom_id}", render_string
			page.visual_effect(:highlight, "is_precinct_#{@category.dom_id}")
		end
  end
  
end
