class ExperiencesController < ProductsController
  def index
    if params[:category_id]
      @category = ProductCategory.find_by_tagid(params[:category_id])
      @category_experiences = ProductCategoryExperience.paginate :include => [:category], :conditions => ["category_id = ?", @category.id], :per_page => 30, :page => params[:page], :order => "product_categories.position"
    else
      @category_experiences = ProductCategoryExperience.paginate :include => [:category], :per_page => 30, :page => params[:page], :order => "product_categories.position"
    end
  end

  def new
    @experience = ProductCategoryExperience.new
    if params[:id]
      @experience.category_id = params[:id]
      @category = ProductCategory.find(params[:id])
      @select_options = create_select_options(params[:id], @category.valid_children, {:text => :name_zh, :include_blank => true})
    else
      @select_options = []
    end
  end

  def create
    @experience = ProductCategoryExperience.new(params[:experience])
    @experience.category_id = params[:category_id] unless params[:category_id].blank?
    if @experience.save
      flash[:success] = "指数创建成功！"
      redirect_to experience_url(@experience)
    else
      flash[:error] = "指数创建失败！"
      render :action => "new"
    end
  end

  def edit
    @experience = ProductCategoryExperience.find(params[:id])
    collention = @experience.category.valid_children.any? ? @experience.category.valid_children : @experience.category.parent.valid_children
    @select_options = create_select_options(@experience.category_id, collention, {:text => :name_zh, :include_blank => true})
    @experience.category_id = @experience.category.parent.id unless @experience.category.valid_children.any?
  end

  def update
    @experience = ProductCategoryExperience.find(params[:id])
    if @experience.update_attributes(params[:experience])
      @experience.update_attribute(:category_id, params[:category_id]) unless params[:category_id].blank?
      flash[:success] = "指数更新成功！"
      redirect_to experience_url(@experience)
    else
      flash[:error] = "指数更新失败！"
      render :action => "edit"
    end
  end

  def show
    @experience = ProductCategoryExperience.find(params[:id])
  end

  private

  #create options for select_tag
  # choice - which option selected
  # Options
  # :text - The method to use on collection objects to get the text for the option
  # :value - The method to use on collection objects to get the value attribute for the option
  # :include_blank - Includes a blank option at the top of cascaded boxes
  def create_select_options(choice, collection, options={})
    options[:text] ||= 'name'
    options[:value] ||= 'id'
    options[:include_blank] = true if options[:include_blank].nil?
    options[:clear] ||= []
    pre = options[:include_blank] ? "<option value="">""</option>" : ""
    collection.each { |c| pre << "<option value=#{c.send(options[:value])} #{"selected=\"selected\"" if choice == c.send(options[:value])}>#{c.send(options[:text])}</option>" }
    pre
  end
end
