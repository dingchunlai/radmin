class RemarksController < ApplicationController

  layout 'review'

  def index
    @CITIES = {11910 => "上海",12117 => "苏州",12122 => "南京",12301 => "宁波",12306 => "杭州",12118 => "无锡"}
    @type = params[:type].to_i
    @editor = params[:editor]
    @content = params[:content]
    @status = params[:status].to_i
    @city = params[:city]
    @praise = params[:praise].to_i
    @score = params[:score].to_s
    @firm_name = params[:firm_name]
    @begintime = params[:begintime]
    @endtime = params[:endtime]
    conditions = []
    if @type == 6
      conditions << "parent_id is not null"
    else
      conditions << "id > 0"
      conditions << "resource_type = 'DecoFirm'" if @type == 1
      conditions << "resource_type in ('DecorationDiaryPost','DecorationDiary')" if @type == 2
      conditions << "resource_type = 'DecoEvent'" if @type == 3
      conditions << "resource_type = 'Case'" if @type == 4
      conditions << "resource_type = 'HejiaCase'" if @type == 5
      conditions << "resource_type = 'DecoIdea'" if @type == 7
      conditions << "resource_type = 'Coupon'" if @type == 8
    end
    conditions << "score = '#{@score}'" if @score.to_i != 0

    conditions << "status = 1" if @status == 1
    conditions << "status = 0" if @status == 2
    conditions << "praise > 0" if @praise == 1
    conditions << "praise = 0" if @praise == 2
    if @city.to_i > 0
      if @type == 8
        coupons = Coupon.find(:all, :conditions => ["city_id = #{COUPON_CITIE_HANZI.index(@CITIES[@city.to_i])}"])
        conditions << "resource_id in (#{coupons.map(&:id).join(',')}) and resource_type='Coupon'" if coupons.count > 0
      else
        diary_array = []
        event_array = []
        case_array = []
        deco_idea = []
        if @city.to_i == 11910
          firms = DecoFirm.find(:all, :conditions => "city=11910")
        else
          firms = @city.to_i == 12122 ? [] : DecoFirm.find(:all, :conditions => "district=#{@city}")
        end
        if firms.count > 0
          firms.each do |firm|
            firm.decoration_diaries && firm.decoration_diaries.each do |diary|
              diary_array << diary.decoration_diary_posts.map(&:id)
            end
            event_array << firm.events.map(&:id).join(',')
            case_array << firm.cases.map(&:id).join(',')
            deco_idea << firm.deco_ideas.map(&:id).join(',')
          end
          diary_array = diary_array.flatten.join(',')
          array = firms.map(&:id).join(',')
          conditions << "((resource_id in (#{array}) and resource_type='DecoFirm') or (resource_id in (#{diary_array}) and resource_type='DecorationDiaryPost') or (resource_id in (#{event_array}) and resource_type='DecoEvent') or (resource_id in (#{case_array}) and resource_type in ('Case','HejiaCase')) or (resource_id in (#{deco_idea}) and resource_type='DecoIdea'))"
        end
      end
    end
    
    unless (firm = DecoFirm.find(:first, :conditions => ["name_zh=?", @firm_name])).nil?
      diary_array = [0]
      event_array = [0]
      case_array = [0]
      deco_idea = [0]
      firm.decoration_diaries && firm.decoration_diaries.each do |diary|
        diary_array << diary.decoration_diary_posts.map(&:id)
      end
      event_array << firm.events.map(&:id).join(',')
      case_array << firm.cases.map(&:id).join(',')
      deco_idea << firm.deco_ideas.map(&:id).join(',')
      diary_array = diary_array.flatten.join(',')
      conditions << "((resource_id=#{firm.id} and resource_type='DecoFirm') or (resource_id in (#{diary_array}) and resource_type='DecorationDiaryPost') or (resource_id in (#{event_array}) and resource_type='DecoEvent') or (resource_id in (#{case_array}) and resource_type in ('Case','HejiaCase')) or (resource_id in (#{deco_idea}) and resource_type='DecoIdea'))"
    end

    if @editor
      user = HejiaUserBbs.find_by_USERNAME @editor
      conditions << "user_id=#{user.USERBBSID}" if user
    end
    conditions << "content like '%#{@content}%'" unless @content.blank?
    conditions << "created_at >= '#{@begintime}'" if @begintime && @begintime != ''
    conditions << "created_at <= '#{@endtime}'" if @endtime && @endtime != ''
    if @type == 0 && @city.to_i == 0 && firm.nil?
      #海尔专题的留言也写到这个表,所以这个resource_type=haier_zhuanti_jiadian_waterheater要处理下.
      conditions << 'resource_type not in (\'haier_zhuanti_jiadian_waterheater\')'
    end
    @remarks = Remark.paginate :page => params[:page], :per_page => 20, :conditions => conditions.join(' and '), :order => "created_at desc"
  end

  def show
    @remark = Remark.find(params[:id])
  end

  def new
    @remark = Remark.new
  end

  def edit
    @remark = Remark.find(params[:id])
  end

  def create
    @remark = parent.comments.build(params[:remark])
    @remark.user = current_user
    @remark.save
    redirect_to parent_remarks_url
  end
  



  def update
    @remark = Remark.find(params[:id])

    if @remark.update_attributes(params[:remark])
      flash[:notice] = 'Remark was successfully updated.'
      redirect_to params[:url]
    else
      render :action => "edit"
    end
  end

  def destroy
    if params[:id].blank?
      Remark.delete_all(["id in (?)", params[:remark_ids].split(",")])
    else
      @remark = Remark.find(params[:id])
      @remark.destroy
    end
    redirect_to request.env["HTTP_REFERER"]
  end
  # Make non-essential
  def non_essential
    Remark.update_all("is_essence = 0", ["id in (?)", params[:remark_ids].split(",")])
    redirect_to request.env["HTTP_REFERER"]
  end
  # Make cream
  def essential
    Remark.update_all("is_essence = 1", ["id in (?)", params[:remark_ids].split(",")])
    redirect_to request.env["HTTP_REFERER"]
  end
  
  # Bulk delete
  def mach_destroy
    remarks = Remark.find(:all, :conditions => ["id in (?)", params[:remark_ids].split(",")])
    remarks.each do |remark|
      remark.destroy
    end
    redirect_to request.env["HTTP_REFERER"]
  end

  def shen_he
    Remark.update_all("status = 1", ["id in (?)", params[:remark_ids].split(",")])
    redirect_to request.env["HTTP_REFERER"]
  end

  def qu_xiao_shen_he
    Remark.update_all("status = 0", ["id in (?)", params[:remark_ids].split(",")])
    redirect_to request.env["HTTP_REFERER"]
  end

  ## 设置好、中、差评
  def make_score
    if params[:score].to_i == 0
      Remark.update_all("score = null", ["id in (?)", params[:remark_ids].split(",")])
    else
      Remark.update_all("score = #{params[:score].to_i}", ["id in (?)", params[:remark_ids].split(",")])
    end
    redirect_to request.env["HTTP_REFERER"]
  end
  
  private #-----------------------------  private  ------------------------------------------
  
end
