class Decos::RegistersController < DecosController

  def index
    factory_ids = @firm.rad_factories.map(&:ID)
    @registers = DecoRegister.paginate  :per_page => 20, :page => params[:page],
      :conditions => ["event_id in (?) and (state is NULL or state <>'-1')", factory_ids],
      :order => "deco_registers.created_at desc"
  end

  def edit
    @register = DecoRegister.find(params[:id])
  end

  def update
    @register = DecoRegister.find(params[:id])
    if @register.update_attributes(params[:register])
      flash[:notice] = "报名更新成功！"
      redirect_to deco_registers_url
    else
      flash[:notice] = "报名更新出错！"
      render :action => "edit"
    end
  end

  def destory
    DecoRegister.update_all("state = '-1'", "id in (#{params[:id]})") unless params[:id].blank?
    redirect_to deco_registers_url
  end

end
