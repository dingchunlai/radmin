class ParamItemsController < ProductsController
 
  def new
    @param_item = ProductCategoryParamItem.new
    if params[:param_id]
      @param_item.param_id = params[:param_id]
      @param = ProductCategoryParam.find(params[:param_id])
      @category = @param.category
      @category_params = @category.params
    end
  end

  def create
    @param_item = ProductCategoryParamItem.new(params[:param_item])
    @param = ProductCategoryParam.find(params[:param_item][:param_id])
    if @param_item.save
      flash[:success] = "选项创建成功！"
      redirect_to param_url(@param)
    else
      flash[:error] = "选项创建失败！"
      render :action => "new"
    end
  end

  def edit
    @param_item = ProductCategoryParamItem.find(params[:id])
    @param = @param_item.param
    @category = @param.category
    @category_params = @category.params
  end

  def update
    @param_item = ProductCategoryParamItem.find(params[:id])
    if @param_item.update_attributes(params[:param_item])
      flash[:success] = "选项更新成功！"
      redirect_to param_url(@param_item.param)
    else
      flash[:error] = "选项更新失败！"
      render :action => "edit"
    end
  end

  def destroy
    @param_item = ProductCategoryParamItem.find(params[:id])
    @param_item.destroy
    flash[:success] = "删除成功！"
    redirect_to param_url(@param_item.param)
  end

end
