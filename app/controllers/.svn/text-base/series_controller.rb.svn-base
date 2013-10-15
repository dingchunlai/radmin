class SeriesController < ProductsController

  def index
    @series = ProductSerie.paginate :per_page => 20, :page => params[:page], :order => "brand_id desc"
  end

  def show
    @serie = ProductSerie.find(params[:id])
  end

  def new
    @serie = ProductSerie.new
    if params[:brand_id]
      @brand = ProductBrand.find(params[:brand_id])
      @serie.brand_id = @brand.id
      @categories = @brand.categories
    else
      @categories = ProductCategory.second_class
    end
  end

  def create
    @serie = ProductSerie.new(params[:serie])
    if @serie.save
      flash[:success] = "系列创建成功！"
      redirect_to brand_url(@serie.brand)
    else
      flash[:error] = "系列创建失败！"
      render :action => "new"
    end
  end

  def edit
    @serie = ProductSerie.find(params[:id])
    @brand = @serie.brand
    @categories = @brand.categories
  end

  def update
    @serie = ProductSerie.find(params[:id])
    if @serie.update_attributes(params[:serie])
      flash[:success] = "系列更新成功！"
      redirect_to brand_url(@serie.brand)
    else
      flash[:error] = "系列更新失败！"
      render :action => "edit"
    end
  end

  def destroy
    ProductSerie.find(params[:id]).destroy
    redirect_to series_url
  end
end
