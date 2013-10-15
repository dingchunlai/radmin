class AdminApplicationsController < ApplicationController
  layout 'decocompany'

  def index
    @name = params[:name]
    @tel = params[:tel]
    @company = params[:company]
    @marker_1 = params[:marker_1]
    @marker_2 = params[:marker_2]
    @status_1 = params[:status_1]
    @status_2 = params[:status_2]
    @city = params[:city]
    @from_type = params[:from_type]
    @begintime = params[:begintime]
    @endtime = params[:endtime]
    conditions = []
    conditions << "id>0"
    conditions << "name='#{@name}'" unless @name.nil?
    conditions << "tel=#{@tel}" unless @tel.nil?
    conditions << "deco_firm_id=#{DecoFirm.find(:first, :conditions =>["name_zh='#{@company}'"]).id}" unless @company.nil?
    conditions << "marker like '%#{@marker_1}%'" unless @marker_1.blank?
    conditions << "(marker is null or marker='')" if @marker_2.to_i == 1
    conditions << "marker is not null and marker<>''" if @marker_2.to_i == 2
    conditions << "status=0" if @status_1.to_i == 1
    conditions << "status=1" if @status_1.to_i == 2
    conditions << "status<>'-1'" if @status_2.to_i == 1
    conditions << "status='-1'" if @status_2.to_i == 2
    unless @city.blank?
      firms = @city.to_i == 11910 ? DecoFirm.find(:all, :conditions => ["city=?",@city.to_i]) :DecoFirm.find(:all, :conditions => ["district=?",@city.to_i])
      firms_ids = firms.map(&:id).join(',') unless firms.blank?
      firms_ids = firms_ids.size > 0 ? firms_ids : "null"
      conditions << "deco_firm_id in (#{firms_ids})"
    end
    unless @from_type.blank?
      conditions << "from_type = #{@from_type}"
    end
    conditions << "created_at >= '#{@begintime}'" if @begintime && @begintime != ''
    conditions << "created_at <= '#{@endtime}'" if @endtime && @endtime != ''
    @applicants = Applicant.paginate :page => params[:page], :per_page => 20, :conditions => conditions.join(" and "), :order => "created_at desc"
  end

  def update_applicant_marker
    unless params[:applicant_id].blank?
      Applicant.update_all("marker = '#{params[:marker]}'", "id = #{params[:applicant_id]}")
      render :text => 'true'
    end
  end

  def applicants_del
    selected_id = params[:applicantid] || params[:applicant][:selected_ids]
    if !selected_id.nil?
      Applicant.destroy_all(:id => selected_id)
    end
    redirect_to request.env["HTTP_REFERER"]
  end

end
