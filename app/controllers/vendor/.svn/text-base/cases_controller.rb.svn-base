class Vendor::CasesController < VendorController

  def index
    @cases = VendorCase.paginate :page => params[:page], :per_page => 15, :order => "created_at desc", :conditions => ["vendor_id = ?", @vendor.id]
  end

  def show
    @case = VendorCase.find(params[:id])
  end

  def new
    @case = VendorCase.new
    @case.vendor_id = @vendor.id
  end

  def create
    @case = VendorCase.new(params[:case])
    if @case.save
      flash[:success] = "案例添加成功！"
      redirect_to vendor_case_url(@case)
    else
      flash[:error] = "案例添加失败！"
      render :action => "new"
    end
  end

  def edit
    @case = VendorCase.find(params[:id])
  end

  def update
    @case = VendorCase.find(params[:id])
    if @case.update_attributes(params[:case])
      flash[:success] = "案例更新成功！"
      redirect_to vendor_case_url(@case)
    else
      flash[:error] = "案例更新失败!"
      render :action => "edit"
    end
  end

  def destroy
    @case = VendorCase.find(params[:id])
    @case.destroy
    redirect_to vendor_cases_url
  end
end
