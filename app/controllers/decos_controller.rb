class DecosController < ApplicationController
  layout "deco"
  
  before_filter :find_firm, :except => [:login, :login_action]
  
  uses_tiny_mce :options => {
    :language => 'zh',
    :theme => 'advanced',
    :width => "660px",
    :convert_urls => false,
    :relative_urls => false,
    :visual => false,
    :theme_advanced_buttons1 => "bold,italic,underline,strikethrough,|,justifyleft,justifycenter,justifyright,justifyfull,|,bullist,numlist,|,formatselect,fontselect,fontsizeselect,|,outdent,indent,blockquote,|,undo,redo",
    :theme_advanced_buttons2 => "tablecontrols,|,hr,removeformat,visualaid,code |,hr,removeformat,visualaid,|,link,unlink,anchor,image,upload,cleanup,|,forecolor,backcolor,code",
    :theme_advanced_buttons3 => "",
    :theme_advanced_resizing => true,
    :theme_advanced_resize_horizontal => false,
    :theme_advanced_toolbar_location => "top",
    :theme_advanced_toolbar_align => "left",
    :theme_advanced_statusbar_location => "bottom",
    :plugins => %w{ table fullscreen upload}
  },
    :only => [:new, :create, :edit, :update]
  
  def index
  end
  
  def edit
    @cities = get_cities
    @areas = get_areas2(@firm.city.to_i)
    @areas2 = get_areas2(@firm.district.to_i)
  end
  
  def update
    params[:firm][:priority] = @firm.priority.to_s
    params[:firm][:msg_phone] = nil if params[:firm][:is_need_send_msg].to_i == 0
    if @firm.update_attributes((params[:firm]))
      CACHE.delete("firms/id/#{@firm.id}")#更新公司信息缓存
      flash[:success] = "企业信息更新成功！"
      redirect_to "/decos/edit"
    else
      render :text => alert("更新失败，请根据提示填写") + js("history.back(-1);")
    end
  end
  
  def select_area
    @area = get_areas2(params[:cityid])
    render :partial => "select_area"
  end
  
  def select_area2
    @area2 = get_areas2(params[:cityid])
    render :partial => "select_area2"
  end
  
  def get_areas #取得上海区域Hash
    as = DecoInfo.find(:all, :select => "tagid,tagname", :from => "HEJIA_TAG", :conditions => "tagfatherid = 11910")
    areas = Hash.new
    areas[0] = "请选择"
    as.each do |a|
      areas[a.tagid.to_i] = a.tagname
    end
    return areas
  end
  
  def get_areas2(cityid) #取得各地区域Hash
    return {} if cityid.to_i == 0
    as = Tag.find(:all, :select => "TAGID, TAGNAME",  :conditions => "TAGFATHERID = #{cityid}")
    areas = Hash.new
    as.each do |a|
      areas[a.TAGID] = a.TAGNAME
    end
    areas
  end
  
  # 获得所有省份  
  def get_cities
    Tag.provinces_to_hash
  end
  private :get_cities
   
  def logininfo
    hf = "document.write(\"<iframe name='hideiframe_login' width='0' height='0' style='display: none;'></iframe>\");"
    if user_logged_in?
      #个人用户已登录状态
      render :text => hf + "document.write(\"<a class='myaccount' href='/orders'>我的和家</a><a class='glogout' href='http://member.51hejia.com/member/loginout?forward=\" + top.location.href + \"' target='hideiframe_login'>退出</a>\");"
    else
      if cookies["vendor_id"].nil?
        #未登录状态
        render :text => hf + "document.write(\"<a class='glogin' href='/account/login?forward=\" + top.location.href + \"'>会员登录</a><a class='gsignup' href='http://member.51hejia.com/member/reg?forward=\" + top.location.href + \"' target='_blank'>注册</a>\");"
      else
        #企业用户已登录状态
        render :text => hf + "document.write(\"<a class='myaccount' href='http://member.51hejia.com/vendor'>我的店铺</a><a class='glogout' href='http://member.51hejia.com/member/loginout?forward=\" + top.location.href + \"' target='hideiframe_login'>退出</a>\");"
      end
    end
  end

  #留言管理
  def manage_comments
    @is_replied = params[:is_replied]   #留言状态
    @username = params[:username] #用户姓名，存于HEJIA_USER_BBS这张表中
    @remark_type = params[:remark_type] #判断留言是对公司、日记、优惠券还是案例
    conditions = []
    order = []
    if @is_replied.nil?
      order << " created_at desc"
    elsif  @is_replied.to_i == 1
      conditions << "is_replied=0"
      order << " created_at desc"
    elsif @is_replied.to_i == 2
      conditions << "is_replied=1"
      order << " updated_at desc"
    end
    #diraies_id = CACHE.fetch("firm/diraies/id/#{@firm.id}", 1.hours) do # 缓存公司的日记ID数，因要匹配下面的查询条件，故用正则处理
    diary_id = []
    @firm.decoration_diaries.each do |diary|
      diary_id += diary.decoration_diary_posts.map(&:id)
    end
    diraies_id = diary_id.blank? ? 'null' : diary_id.join(",")
    #end
    events_id = CACHE.fetch("firm/events/id/#{@firm.id}",1.hours) do # 缓存公司的优惠券ID数，因要匹配下面的查询条件，故用正则处理
      event_id = @firm.events.map{|f| ",#{f["id"]}"}
      if event_id.size == 0
        event_id = 0
      else
        event_id[0] = event_id[0].gsub(/(,)/,'')
      end
      event_id
    end
    cases_id = @firm.cases.blank? ? 'null' : @firm.cases.map(&:id).join(',')

    if @remark_type.nil?
      conditions << "((resource_id = #{@firm.id} AND resource_type = 'DecoFirm') OR (resource_type = 'DecorationDiaryPost' AND resource_id IN (#{diraies_id})) OR (resource_type = 'DecoEvent' AND resource_id IN (#{events_id})) OR (resource_type = 'Case' AND resource_id IN (#{cases_id})))"
    elsif @remark_type.to_i == 1
      conditions << "resource_id = #{@firm.id} AND resource_type = 'DecoFirm'"
    elsif @remark_type.to_i == 2
      conditions << "resource_type = 'DecorationDiaryPost' AND resource_id IN (#{diraies_id})"
    elsif @remark_type.to_i == 3
      conditions << "resource_type = 'DecoEvent' AND resource_id IN (#{events_id})"
    elsif @remark_type.to_i == 4
      conditions << "resource_type = 'Case' AND resource_id IN (#{cases_id})"
    end
    if @username
      name = HejiaUserBbs.find(:first, :conditions => ["USERNAME = ?",@username])
      conditions << "user_id = #{name.id}"
    end
    @comments = Remark.paginate :page => params[:page],
      :per_page => 20,
      :conditions => conditions.join(' and '),
      :order => order
  end

  #对某个留言进行回复
  def reply_comment
    @comment = Remark.find(params[:id])
    if @new_reply = Remark.find(:first,:conditions=>["parent_id =#{@comment.id}"])
      @its_id = @new_reply.id
    else 
      @new_reply = Remark.new
    end
    @parent_id = @comment.id
  end

  def create
    its_id = params[:its_id]
    @new_reply = its_id.blank? ? Remark.new(params[:new_reply]) : Remark.find(its_id)
    if its_id.blank?
      @new_reply.save
      old_comment = Remark.find(@new_reply.parent_id)
      old_comment.update_attribute("is_replied",1)
    else
      @new_reply.update_attributes(params[:new_reply])
    end
    redirect_to "/decos/manage_comments"
  end
  #删除comment记录
  def delete_all
    if !params[:comment_id].nil?
      Remark.destroy_all(:id => params[:comment_id])
    end

    redirect_to request.env["HTTP_REFERER"]
  end

  #批量删除施工图片
  def photos_destory
    if params[:photo_id]
      photo = DecoPhoto.find(params[:photo_id].last.to_i)
      decofirm = DecoFirm.find(photo.entity_id)
      if DecoPhoto.delete_all(:id => params[:photo_id])
        new_count = decofirm.photos_count.to_i - params[:photo_id].size
        decofirm.update_attribute("photos_count",new_count )
        redirect_to request.env["HTTP_REFERER"]
      end
    end
  end

  def events
    order_number = 1
    params[:events].each do |id|
      DecoEvent.update_all("LIST_INDEX = #{order_number}",:ID=>id)
      order_number += 1
    end
    render :nothing => true
  end

  ## 竞标列表
  def bid_records
    @bid_records = BidRecord.find(:all, :conditions => ["? < expired_time", Time.now], :order => "id desc")
  end

  ## 竞标详细信息页
  def br_show
    @bid_record = BidRecord.find(params[:br_id])
  end

  ## 公司竞价页
  def br_info
    @tag_type, @tag_id = params[:tag].split("-")
    @tag_id = @tag_id.to_i

    @bid_record = BidRecord.find(params[:br_id])
    @bids = @bid_record.radmin_bids(@tag_type, @tag_id)

    if @tag_type == "PRICE"
      @bid = Bid.find(:first, :conditions => ["bid_record_id = ? and deco_firm_id = ? and price = ?", @bid_record, @firm.id, @tag_id])
    else
      @bid = Bid.find(:first, :conditions => ["bid_record_id = ? and deco_firm_id = ? and style = ?", @bid_record, @firm.id, @tag_id])
    end

    city = @firm.city.blank? ? @firm.district : @firm.city
    if @bid.nil?
      @bid = Bid.new(:bid_record_id => @bid_record.id, :deco_firm_id => @firm.id, :expired_time => @bid_record.expired_time)
    end
    @bid.city = city
    
    if @tag_type == "PRICE"
      @tag_name = BidRecord::PRICE.values_at(@tag_id)
      @bid.price = @tag_id
    else
      @tag_name = BidRecord::STYLE.values_at(@tag_id)
      @bid.style = @tag_id
    end
  end

  ## 创建竞价
  def bid_create
    @bid = Bid.new(params[:bid])
    if @bid.save
      redirect_to :action => "br_info", :tag => @bid.price.blank? ? "STYLE-#{@bid.style}" : "PRICE-#{@bid.price}", :br_id => @bid.bid_record_id
    else
      if @bid.price.blank?
        @tag_type = "STYLE"
        @tag_id = @bid.style
      else
        @tag_type = "PRICE"
        @tag_id = @bid.price
      end
      @bid_record = BidRecord.find(params[:bid][:bid_record_id])
      @bids = @bid_record.radmin_bids(@tag_type, @tag_id)
      render :action => "br_info"
    end
  end

  ## 修改竞价
  def bid_update
    @bid = Bid.find(params[:bid_id])
    if @bid.update_attributes(params[:bid])
      redirect_to :action => "br_info", :tag => @bid.price.blank? ? "STYLE-#{@bid.style}" : "PRICE-#{@bid.price}", :br_id => @bid.bid_record_id
    else
      if @bid.price.blank?
        @tag_type = "STYLE"
        @tag_id = @bid.style
      else
        @tag_type = "PRICE"
        @tag_id = @bid.price
      end
      @bid_record = @bid.bid_record
      @bids = @bid_record.radmin_bids(@tag_type, @tag_id)
      @bid.attributes = params[:bid]
      render :action => "br_info"
    end
  end



end
