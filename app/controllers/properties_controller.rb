class PropertiesController < ProductsController
  before_filter :check_product_super_role
  
  def index
    if params[:category_id]
      @category = ProductCategory.find_by_tagid(params[:category_id])
      if @category.children.any?
        @category_properties = ProductCategoryProperty.paginate :include => [:category], :conditions => ["category_id in (?)", @category.children], :per_page => 30, :page => params[:page], :order => "product_category_properties.category_id, product_category_properties.position"
      else
        @category_properties = ProductCategoryProperty.paginate :include => [:category], :conditions => ["category_id = ?", @category.id], :per_page => 30, :page => params[:page], :order => "product_category_properties.position"
      end
    else
      @category_properties = ProductCategoryProperty.paginate :per_page => 30, :page => params[:page], :order => "product_category_properties.category_id, product_category_properties.position"
    end
  end

  def show
    @property = ProductCategoryProperty.find(params[:id])
  end

  def new
    @property = ProductCategoryProperty.new
  end

  def create
    @property = ProductCategoryProperty.new(params[:property])
    if @property.save
      flash[:success] = "属性创建成功！"
      redirect_to property_url(@property)
    else
      flash[:error] = "属性创建失败！"
      render :action => "new"
    end
  end

  def edit
    @property = ProductCategoryProperty.find(params[:id])
    @category_parent_id = @property.category ? @property.category.parent_id : nil
  end

  def update
    @property = ProductCategoryProperty.find(params[:id])
    if @property.update_attributes(params[:property])
      flash[:success] = "属性更新成功！"
      redirect_to property_url(@property)
    else
      flash[:error] = "属性更新失败！"
      render :action => "edit"
    end
  end

  def destroy
    ProductCategoryProperty.find(params[:id]).destroy
    redirect_to properties_url
  end

  def move
    if ["move_lower", "move_higher", "move_to_top", "move_to_bottom"].include?(params[:method]) and params[:id] =~ /^\d+$/
      ProductCategoryProperty.find(params[:id]).send(params[:method])
    end
    redirect_to :action => :index
  end
end
