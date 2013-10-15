class BrandExperiencesController < ProductsController

  def index
    if params[:brand_id]
      @brand_experiences = ProductBrandExperience.paginate :per_page => 30, :page => params[:page],
        :conditions => ["brand_id = ?", params[:brand_id]], :order => "position"
    elsif params[:category_id]
      @brand_experiences = ProductBrandExperience.paginate :per_page => 30, :page => params[:page],
        :conditions => ["category_id = ?", params[:category_id]], :order => "position"
    else
      @brand_experiences = ProductBrandExperience.paginate :per_page => 30, :page => params[:page], :order => "position"
    end
  end

  #  def new
  #    @brand_experience = ProductBrandExperience.new
  #    @brand = ProductBrand.find(1)
  #  end

  def create
    @brand_experience = ProductBrandExperience.new(params[:brand_experience])
    if @brand_experience.save
      flash[:success] = "品牌体验项创建成功."
      redirect_to brand_experiences_url
    else
      flash[:error] = "品牌体验项创建失败."
      redirect_to setup_brand_experience_url(params[:brand_experience_brand_id])
    end
  end

  def setup
    @brand_experience = ProductBrandExperience.new
    @brand_experience.brand_id = params[:id]
  end

  def edit
    @brand_experience = ProductBrandExperience.find(params[:id])
  end

  def update
    @brand_experience = ProductBrandExperience.find(params[:id])
    if @brand_experience.update_attributes(params[:brand_experience])
      flash[:success] = "品牌体验项更新成功."
      redirect_to brand_experiences_url
    else
      flash[:error] = "品牌体验项更新失败."
      redirect_to edit_brand_experience_url(params[:id])
    end
  end
  
  def is_disabled
    @brand_experience = ProductBrandExperience.find(params[:id])
    checked_value = params[:cvalue]
    if checked_value == "true"
      @brand_experience.update_attribute(:is_disabled, 1)
    else
      @brand_experience.update_attribute(:is_disabled, 0)
    end
    render :update do |page|
			page.visual_effect(:highlight, "is_disabled_#{@brand_experience.id}")
		end
  end
end
