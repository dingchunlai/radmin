class LibraryBrandsController < ProductsController
  in_place_edit_for :library_brand, :editor_point
  in_place_edit_for :library_brand, :editor_view_count

  def index
    if params[:category_id]
      @brands = LibraryBrand.paginate :per_page => 20, :page => params[:page],
        :conditions => ["category_id = ?", params[:category_id]]
    elsif params[:brand_id]
      @brands = LibraryBrand.paginate :per_page => 20, :page => params[:page],
        :conditions => ["brand_id = ?", params[:brand_id]]
    else
      @brands = LibraryBrand.paginate :per_page => 20, :page => params[:page]
    end
  end

  def new
    @brand = LibraryBrand.new
  end

  def create
    @brand = LibraryBrand.new(params[:library_brand])
    @brand.view_count = @brand.brand.view_count if @brand.brand
    @brand.category_id = @brand.category_parent_id
    @brand.category_id = params[:category_id] unless params[:category_id].blank?
    @brand.brand_question_query = @brand.brand.name_zh if @brand.brand && @brand.brand_question_query.blank?
    @brand.category_question_query = @brand.category.name_zh if @brand.category && @brand.category_question_query.blank?
    @brand.picture_tag = @brand.category.name_zh if @brand.category && @brand.picture_tag.blank?
    if @brand.save
      flash[:success] = "品牌创建成功！"
      redirect_to library_brand_url(@brand)
    else
      flash[:error] = "品牌创建失败！"
      render :action => "new"
    end
  end

  def show
    @brand = LibraryBrand.find(params[:id])
    category = @brand.category
    conditions = []
    if category && category.valid_children.any?
      children = category.valid_children.collect{|c| c.id}.join(",")
      category ? (conditions << "category_id in (#{children})") : nil
    else
      category ? (conditions << "category_id = '#{category.id}'") : nil
    end
    @brand ? (conditions << "brand_id = '#{@brand.brand_id}'") : nil
#    conditions << "status = 1"
    conditions << "is_delete = 0"
    @products = Product.paginate :all, :per_page => 20, :page => params[:page],
      :conditions => conditions.join(" and "), :order => "created_at desc"
  end

  def edit
    @library_brand = LibraryBrand.find(params[:id])
    collention = @library_brand.category.valid_children.any? ? @library_brand.category.valid_children : @library_brand.category.parent.valid_children
    @select_options = create_select_options(@library_brand.category_id, collention, {:text => :name_zh, :include_blank => true})
    @library_brand.category_parent_id = @library_brand.category_id
    @library_brand.category_parent_id = @library_brand.category.parent.id unless @library_brand.category.valid_children.any?
  end

  def update
    @brand = LibraryBrand.find(params[:id])
    if @brand.update_attributes(params[:library_brand])
      @brand.category_id = @brand.category_parent_id
      @brand.category_id = params[:category_id] unless params[:category_id].blank?
      @brand.save
      flash[:success] = "品牌更新成功！"
      redirect_to library_brand_path(@brand)
    else
      flash[:error] = "品牌更新失败！"
      render edit_library_brand_path(@brand)
    end
  end

  def destroy
    @library_brand = LibraryBrand.find(params[:id])
    @library_brand.destroy

    render :update do |page|
      page.visual_effect :highlight, @library_brand.dom_id
      page.remove @library_brand.dom_id
    end
  end

  private

  # create options for select_tag
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
