class Decos::QuotationsController < DecosController
  layout "deco"
  before_filter :find_firm
  
  def index
    @quotations = @firm.quotations.paginate :per_page => 20, :page => params[:page], :order => "id desc"
  end
  
  def show
		@quotation = DecoQuotation.find(params[:id])
		unless @quotation.firms.include?(@firm)
			flash[:notice] = "对不起，您没有该报价单的管理权限！"
			redirect_to deco_quotations_url
		end
  end

  def new
    @quotation = DecoQuotation.new
  end
  
  def create
    @quotation = DecoQuotation.new(params[:quotation])
    @quotation.firms << @firm
    if @quotation.save
      flash[:success] = "报价单创建成功！"
      redirect_to deco_quotation_url(@quotation)
    else
      flash[:notice] = "报价单创建失败！"
      render :action => "new"
    end
  end

  def edit
    @quotation = DecoQuotation.find(params[:id])
  end

  def update
    @quotation = DecoQuotation.find(params[:id])
    if @quotation.update_attributes(params[:quotation])
      flash[:success] = "报价单更新成功！"
      redirect_to deco_quotation_url(@quotation)
    else
      flash[:notice] = "报价单更新失败！"
      render :action => "edit"
    end
  end

  def destroy
    @quotation = DecoQuotation.find(params[:id])
    @quotation.destroy
    redirect_to deco_quotations_url
  end
end