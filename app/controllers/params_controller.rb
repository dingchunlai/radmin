class ParamsController < ProductsController
  before_filter :check_product_super_role
  
  def index
    if params[:category_id]
      @category = ProductCategory.find_by_tagid(params[:category_id])
      if @category.children.any?
        @category_params = ProductCategoryParam.paginate :include => [:category], :conditions => ["category_id in (?)", @category.children], :per_page => 30, :page => params[:page], :order => "product_categories.position"
      else
        @category_params = ProductCategoryParam.paginate :include => [:category], :conditions => ["category_id = ?", @category.id], :per_page => 30, :page => params[:page], :order => "product_categories.position"
      end
    else
      @category_params = ProductCategoryParam.paginate :include => [:category], :per_page => 30, :page => params[:page], :order => "product_categories.position"
    end
  end

  def show
    @param = ProductCategoryParam.find(params[:id])
    @param_items = @param.param_items
  end

  def new
    @param = ProductCategoryParam.new
  end

  def create
    @param = ProductCategoryParam.new(params[:param])
    if @param.save
      flash[:success] = "属性创建成功！"
      redirect_to param_url(@param)
    else
      flash[:error] = "属性创建失败！"
      render :action => "new"
    end
  end

  def edit
    @param = ProductCategoryParam.find(params[:id])
    @category_parent_id = @param.category ? @param.category.parent_id : nil
  end

  def update
    @param = ProductCategoryParam.find(params[:id])
    if @param.update_attributes(params[:param])
      flash[:success] = "属性更新成功！"
      redirect_to param_url(@param)
    else
      flash[:error] = "属性更新失败！"
      render :action => "edit"
    end
  end

  def move
    if ["move_lower", "move_higher", "move_to_top", "move_to_bottom"].include?(params[:method]) and params[:id] =~ /^\d+$/
      ProductCategoryParam.find(params[:id]).send(params[:method])
    end
    redirect_to :action => :index
  end

  def is_valid
    @category_param = ProductCategoryParam.find(params[:id])
    checked_value = params[:cvalue]
    if checked_value == "true"
      @category_param.update_attribute(:is_valid, 1)
    else
      @category_param.update_attribute(:is_valid, 0)
    end
    render :nothing => true
  end

  def is_searchable
    @category_param = ProductCategoryParam.find(params[:id])
    checked_value = params[:cvalue]
    if checked_value == "true"
      @category_param.update_attribute(:is_searchable, 1)
    else
      @category_param.update_attribute(:is_searchable, 0)
    end
    render :nothing => true
  end
end
