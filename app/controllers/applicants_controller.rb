class ApplicantsController < ApplicationController

  layout 'deco'
  before_filter :find_firm
  #before_filter :member_validate

  def index
    @status = params[:status]
    @begintime = params[:begintime]
    @endtime = params[:endtime]
    @confirm_begintime = params[:confirm_begintime]
    @confirm_endtime = params[:confirm_endtime]
    conditions = ['status != -1']
    conditions << "status = '1'" if @status.to_i == 1
    conditions << "status = '0'" if @status.to_i == 2
    conditions << "created_at >= '#{@begintime}'" if @begintime && @begintime != ''
    conditions << "created_at <= '#{@endtime}'" if @endtime && @endtime != ''
    conditions << "confirm_at >= '#{@confirm_begintime}'" if @confirm_begintime && @confirm_begintime != ''
    conditions << "confirm_at <= '#{@confirm_endtime}'" if @confirm_endtime && @confirm_endtime != ''
    @applicants_booked_count = @firm.applicants.count(:all, :conditions => ["status=1"])
    if current_deco_id > 0
      @firm = DecoFirm.find(current_deco_id)
      @applicants = @firm.applicants.paginate :page => params[:page],:conditions => conditions.join(' and '),:per_page => 15,:order => 'created_at desc'
    else
      @applicants = @firm.applicants.paginate :page => params[:page],:conditions => conditions.join(' and '),:per_page => 15,:order => 'created_at desc'
    end
  end

  def destroy
    if Applicant.find(params[:id]).update_attribute(:status,-1)
      redirect_to :action => "index"
    else
      render :text => alert("删除失败")+js(top_load("/applicants"))
    end
  end

  def confirm
    @applicant=Applicant.find(params[:id])
    if @applicant.status == 0  # 安全保护，确认status为-1时不被恶意修改
      if @applicant.update_attributes(:status => 1, :confirm_at => Time.now.utc)
        render :text => alert("操作成功：记录已创建/修改!") + js(top_load("/applicants"))
      else
        render :text => alert("操作失败") + js(top_load("/applicants"))
      end
    else
      redirect_to applicants_path
    end
  end

  #限制商家的确认预约定单数;
  def booking_upper_limit
    if params[:company_id] && params[:upper_limit]
      REDIS_DB.set "firm_#{params[:company_id]}_applicants", params[:upper_limit]
    end
    redirect_to :action => :index
  end

end
