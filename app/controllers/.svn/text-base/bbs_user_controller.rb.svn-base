class BbsUserController < ApplicationController

  # 为什么only这些action？不知道，原来逻辑是这样的
  before_filter :user_validate, :only => [:manager, :create, :index]

  #当前编辑个人BBS用户管理页面
  def manager
    @bbs_list = HejiaUserBbs.paginate  :page => params[:page], :per_page => 10,
     :select => "USERBBSID,USERNAME,user_id",
     :conditions => "USERTYPE = 200",
     :group => "user_id", #分组
     :order => "USERBBSID asc"
  end
  
  #批量创建BBS用户信息
  def create
    city = params[:city]
    area = params[:areas]
    name = params[:bbsname]
    names = name.split(/,|，/)
    mess_array = []
    begin
      names.each do |na|
        bbs_user = HejiaUserBbs.new
        bbs_user.BBSID = 0
        bbs_user.USERSPASSWORD = Digest::MD5.hexdigest("111111")
        bbs_user.user_id = current_staff.id
        bbs_user.CITY = area
        bbs_user.AREA = city
        bbs_user.USERTYPE = 200
        bbs_user.deco_id = 0
        bbs_user.ask_expert = 0     #代表普通会员
        bbs_user.USERNAME = na.to_s
        bbs_user.CREATTIME = Time.new
        if bbs_user.valid?
          bbs_user.save
        else
          mess_array << na.to_s
        end
      end
    end
    if mess_array.blank?
      redirect_to :action => 'index'
    else
      redirect_to :action => 'index', :message => "操作失败: "+mess_array.join(",")+" 已经存在"
    end
  end
  #管理员权限，查看某个编辑名下的所有BBS用户名
  def show
    @show_bbs_users = HejiaUserBbs.paginate  :page => params[:page], :per_page => 10,
     :select => "USERBBSID,USERNAME,user_id",
     :conditions => ["user_id = ?",params[:user_id].to_i],
     :order => "USERBBSID asc"
  end
=begin
  #个人用户删除某个用户名
  def delete
    HejiaUserBbs.delete(params[:id])
    redirect_to :action => 'index'
  end
=end

  def delete
    render :text => "请使用用户帐号冻结功能: http://radmin.51hejia.com/hejia_member/list"
  end

  #当前登录用户BBS用户名管理页面
  def index
    if params[:message]
      @message = params[:message].to_s
    end
    @bbs_users = HejiaUserBbs.paginate  :page => params[:page], :per_page => 10,
     :select => "USERBBSID,USERNAME,user_id",
     :conditions => ["user_id = ?", current_staff.id],
     :order => "USERBBSID asc"
    @cities = get_cities
  end
  
  #执行查询某省市下的区县信息
  def select_city
    @area = get_areas2(params[:cityid])
    render :partial => "select_city"
  end
  #根据省市编号取得各省市下的地区域Hash
  def get_areas2(cityid)
    key = "zhaozhuangxiu_areas_2009_12_12_s-c_#{cityid}_Time.now.strftime('%Y%m%d')"
    areas = Array.new
    if PUBLISH_CACHE.get(key).nil?
      if cityid.to_i == 0
        areas = nil
      else
        areas = ArticleTag.find(:all, :select => "TAGID,TAGNAME", :conditions => "TAGFATHERID = #{cityid}")
      end
      PUBLISH_CACHE.set(key,areas)
    else
      areas = PUBLISH_CACHE.get(key)
    end
    return areas
  end
  #取得所有省的hash
  def get_cities
    key = "zhaozhuangxiu_cities1_hash1_s_1_Time.now.strftime('%Y%m%d')"
    citys = Array.new
    if PUBLISH_CACHE.get(key).nil?
      citys = ArticleTag.find(:all, :select => "TAGID,TAGNAME",  :conditions => "TAGFATHERID = 15000")
      PUBLISH_CACHE.set(key,citys)
    else
      citys = PUBLISH_CACHE.get(key)
    end
    return citys
  end
end
