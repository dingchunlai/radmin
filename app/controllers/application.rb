# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  # Pick a unique cookie name to distinguish our session data from others'
  #before_filter :check_block
  include AuthenticatedSystem
  include UserModule
  include PublicModule
  require "_generate"
  require "_link"
  require "_aboutredis" unless RAILS_ENV == "development"
  before_filter :preload_models

  helper_method :parse_xml
  
  def redirect_back
    redirect_to request.env["HTTP_REFERER"]
  end
  
  protected

  def current_deco_id
    (current_user && current_user.deco_id || 0) rescue 0
  end
  helper_method :current_deco_id
  
  def find_firm
    deco_id = staff_logged_in? && session['deco_firm_id'] || current_deco_id
    @firm = DecoFirm.find_firm deco_id if deco_id.to_i > 0
    redirect_to "/member/ulogin" if @firm.nil?
  end

  def preload_models
    ArticleTag
    JfBase
  end

  def member_validate #验证用户身份
    unless user_logged_in?
      render :text => js(top_load("/member/ulogin"))
      return false
    end
  end
  
  def paginate_collection(collection, options = {})
    default_options = {:per_page => 1, :page => 1}
    options = default_options.merge options
    
    pages = Paginator.new self, collection.size, options[:per_page], options[:page]
    first = pages.current.offset
    last = [first + options[:per_page], collection.size].min
    slice = collection[first...last]
    return [pages, slice]
  end
  
  def vendor_validate #验证用户身份
    if cookies["vendor_id"].nil?
      render :text => js(top_load("http://www.51hejia.com"))
      return false
    else
      return true
    end
  end
  
  def need_inneruser
    render :text => "您的IP地址没有访问该界面的权限!" unless request.remote_ip == "58.246.26.58" || request.remote_ip == "127.0.0.1"
  end
  
  def get_userstatus
    rv = "none"
    if user_logged_in?
      rv = "ind"
    else
      rv = "vendor" if !cookies["vendor_id"].nil?
    end
    return rv
  end
  
  def create_filename(filename) #根据单前时间生成文件名
    suffix = session[:upload_filename_suffix]
    if suffix.nil?
      suffix = 1
    else
      suffix += 1
    end
    session[:upload_filename_suffix] = suffix
    filename = filename.downcase
    newname = Time.now.strftime("%Y_%m_%d_%H_%M_%S_#{suffix}")
    return newname + ".jpg" if filename.include?(".jpg")
    return newname + ".gif" if filename.include?(".gif")
    return newname + ".png" if filename.include?(".png")
    return newname + ".bmp" if filename.include?(".bmp")
  end
  
  def get_file(file, save_path) #取得上传的文件并保存，返回已保存的文件名。
    return nil if file.type==String || file.type==Array || file==nil
    if file.original_filename.empty?
      return nil
    else
      filename = create_filename(file.original_filename)
      base_dir="#{RAILS_ROOT}/public#{save_path}"
      FileUtils.mkdir_p base_dir unless File.directory?(base_dir)
      filepath = base_dir+"#{filename}"
      File.open(filepath, "wb") do |f|
        f.write(file.read)
      end
      return filename
    end
  end
  
  def create_tag_link(entityid,tagid,linktype,state=nil)
    tl = HejiaTagLink.new()
    tl.CREATEDATE = getnow()
    tl.ENTITYID = entityid
    tl.TAGID = tagid
    tl.STATUS = 1
    tl.LINKTYPE = linktype
    tl.STATE = state unless state.nil?
    tl.save
  end
  
  def get_user_id_by_cookie_name(cookie_name="ind_id")
    cookie = cookies["#{cookie_name}"]
    if cookie.nil?
      user_id = 0
    else
      user_id = cookie.to_s
      user_id = user_id.gsub("#{cookie_name}=", "").gsub("; path=", "").to_i
    end
    return user_id
  end
  
  def iconv_gb18030(str)
    begin
      str ? Iconv.iconv("UTF-8", "gb18030", str).join("") : str;
    rescue
      str;
    end
  end
  
  def iconv_gb2312(str)
    begin
      str ? Iconv.iconv("UTF-8", "gb2312", str).join("") : str;
    rescue
      str;
    end
  end
  
  def iconv_utf8(str)
    begin
      str ? Iconv.iconv("gb18030", "UTF-8", str).join("") : str;
    rescue
      str;
    end
  end
  
  def strip(str)
    if str
      return str.lstrip.rstrip
    end
  end
  
  def get_user_id_by_cookie_name(cookie_name="ind_id")
    cookie = cookies["#{cookie_name}"]
    if cookie.nil?
      user_id = 0
    else
      user_id = cookie.to_s
      user_id = user_id.gsub("#{cookie_name}=", "").gsub("; path=", "").to_i
    end
    return user_id    
  end
  
  def escape_invalid_characters(initial_str)
    final_str = initial_str.gsub(".js", "").gsub(".JS", "").gsub(".Js", "").gsub(".jS", "")
    final_str = final_str.gsub("<script", "").gsub("</script>", "")
    return final_str
  end
  
  private
  def is_user
    user_id = get_user_id_by_cookie_name()
    if user_id > 0
      #
    else
      redirect_to "/"
    end
  end
  
  def is_editor
    user_id = get_user_id_by_cookie_name()
    if user_id > 0
      ohurs = OracleHejiaUserRole.find(:all, :select => "role_id",
        :conditions => ["user_id = ?", user_id])
      if ohurs.size > 0
        is_editor = 0
        for ohur in ohurs
          role_id = ohur.role_id
          role_name = OracleHejiaRole.find(:first, :select => "name",
            :conditions => ["id = ?", role_id]).name
          if iconv_gb2312(role_name) == "编辑"
            #            if role_id.to_i == 3
            is_editor = 1
            break
          end
        end
        if is_editor == 1
          #
        else  #非编辑登录
          redirect_to "/"
        end
      else  #非编辑登录
        redirect_to "/"
      end
    else  #未登录
      redirect_to "/"
    end
  end
  
  def is_blog_user  
    if !params[:uid].nil?
      user_id = params[:uid]||= get_user_id_by_cookie_name()
    else
      user_id = get_user_id_by_cookie_name()
    end
    
    if user_id.to_i == 0
      redirect_to "http://ask.51hejia.com"
    end
    
  end
  
  def is_admin
    user_id = get_user_id_by_cookie_name()
    if user_id > 0
      ohurs = OracleHejiaUserRole.find(:all, :select => "role_id",
        :conditions => ["user_id = ?", user_id])
      if ohurs.size > 0
        is_admin = 0
        for ohur in ohurs
          role_id = ohur.role_id
          role_name = OracleHejiaRole.find(:first, :select => "name",
            :conditions => ["id = ?", role_id]).name
          if iconv_gb2312(role_name) == "编辑"
            #            if role_id.to_i == 3
            is_admin = 1
            break
          end
        end
        if is_admin == 1
          #
        else  #非编辑登录
          redirect_to "/"
        end
      else  #非编辑登录
        redirect_to "/"
      end
    else  #未登录
      redirect_to "/"
    end
  end
  
  # Check if the client IP is blocked
  def check_block
    if AskBlockedIp.blocked?(request.remote_ip)
      render :text => "blocked", :status => 403
      return false
    end
    if strip(request.remote_ip)[0, 5] == "59.50"
      render :text => "blocked", :status => 403
      return false
    end
    if strip(request.remote_ip)[0, 5] == "59.49"
      render :text => "blocked", :status => 403
      return false
    end
  end
  
  def paging_record(h) #生成分页记录集函数，反馈参数 params[:page] 和 params[:recordcount]
    @pagesize = h["pagesize"].to_i if @pagesize.nil?
    @listsize = h["listsize"].to_i if @listsize.nil?
    @curpage = params[:page].to_i if @curpage.nil?
    @recordcount = params[:recordcount].to_i if @recordcount.nil?

    @pagesize = 12 if @pagesize.to_i < 1
    @listsize = 10 if @listsize.to_i < 1
    @curpage = 1 if @curpage.to_i < 1

    if h["primary_key"].nil?
      primary_key = "id"
    else
      primary_key = h["primary_key"]
    end
    if h["conditions"].nil? || h["conditions"] == ""
      conditions = nil
    else
      conditions = h["conditions"]
    end
    if @recordcount.to_i < 1
      @recordcount = h["model"].count(primary_key, :conditions => conditions, :group => h["group"], :joins => h["joins"])
    end
    @pagecount = (@recordcount.to_f / @pagesize.to_f).ceil
    if @recordcount.to_i < 1
      return []
    else
      return h["model"].find :all,
        :select => h["select"],
        :conditions => conditions,
        :order => h["order"],
        :group => h["group"],
        :joins => h["joins"],
        :offset => @pagesize * (@curpage - 1),
        :limit => @pagesize
    end
  end
  
  def word_filter
    @keyword = trim(params[:keyword])
    @sort_id = params[:sort_id]
    cd = "true"
    cd += " and (old like '%%#{@keyword}%%' or new like '%%#{@keyword}%%')" if pp(@keyword)
    cd += " and sort_id = #{@sort_id}" if pp(@sort_id)
    h = Hash.new
    h["model"] = FilterWord
    h["pagesize"] = 15 #每页记录数
    h["listsize"] = 10 #同时显示的页码数
    h["select"] = "id, old, new, sort_id, created_at"
    #h["primary_key"] = "USERBBSID"
    h["conditions"] = cd
    h["order"] = "id desc"
    @words = paging_record(h)
  end
  

  
  def create_photo_tags_link(entityid,tagid,type_id)
    tl = PhotoPhotosTag.new()
    tl.created_at = getnow()
    tl.updated_at = getnow()
    tl.photo_id = entityid
    tl.tag_id = tagid
    tl.type_id = type_id
    tl.save
  end 
  
  def truncate_u(text, length = 30, truncate_string = "")
    l = 0
    char_array = text.unpack("U*")
    char_array.each_with_index do |c,i|
      l = l + (c<127 ? 0.5 : 1)
      if l >= length
        return char_array[0..i].pack("U*") + (i < char_array.length - 1 ? truncate_string : "")
      end
    end
    return text
  end
  #查找属于该用户和城市的所有BSS用户
  def get_bbs_users_by_conditions(city_id,user_id)
    HejiaUserBbs
    key = "zhaozhuangxiu_bbs_user_2009_12_12_s-1z_#{city_id}_#{user_id}_Time.now.strftime('%Y%m%d%H')"
    bbs_user = Array.new
    if PUBLISH_CACHE.get(key).nil?
      if city_id.to_i == 11910
        bbs_user = HejiaUserBbs.find(:all, :conditions => "AREA = '#{city_id}' and user_id = #{user_id}")
      else
        bbs_user = HejiaUserBbs.find(:all, :conditions => "CITY = '#{city_id}' and user_id = #{user_id}")
      end
      PUBLISH_CACHE.set(key,bbs_user)
    else
      bbs_user = PUBLISH_CACHE.get(key)
    end
    return bbs_user
  end

  def page_not_found!
    render :file => File.join(RAILS_ROOT, 'public/404.html'), :status => 404
  end
  
  
  
  protected


end
