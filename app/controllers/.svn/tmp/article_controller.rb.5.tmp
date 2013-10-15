# -*- coding: utf-8 -*-
class ArticleController < ApplicationController
  before_filter :user_validate  #验证用户身份
  require 'date'
  layouts="article"
  uses_tiny_mce :options => {
    :language => 'zh',
    :theme => 'advanced',
    :width => "760px",
    :convert_urls => false,
    :relative_urls => false,
    :visual => false,
    :theme_advanced_buttons1 => "product,preview,bold,italic,underline,strikethrough,|,justifyleft,justifycenter,justifyright,justifyfull,|,bullist,numlist,|,formatselect,fontselect,fontsizeselect,|,outdent,indent,blockquote,|,undo,redo",
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
  #大分类
  def index1
    @firstlist = ProductCategory.find(:all, :conditions => ["parent_id = ? ", 1])
    render :layout => false
  end

  #二级分类
  def index2
    @fatherid = params[:fatherid]
    if params[:fatherid] && params[:fatherid] != '0'
      @father1 = ProductCategory.find(:all, :conditions => ["parent_id = ?", params[:fatherid]])
      @secondlist = @father1
    end
    render :layout => false
  end

  #三级分类
  def index3
    @fatherid = params[:fatherid]
    if params[:fatherid] && params[:fatherid] != '0'
      @father2 = ProductCategory.find(params[:fatherid])
      @thirdlist = @father2.brands
    end
    render :layout => false
  end

  #搜索入口
  def index
    unless params[:page_size].blank?
      cookies["page_size"] = {:value => params[:page_size], :domain=>".51hejia.com"}
      @page_size = params[:page_size]
    else
      unless cookies[:page_size].blank?
        @page_size = cookies[:page_size]
      else
        @page_size = 20
        cookies["page_size"] = {:value => params[:page_size], :domain=>".51hejia.com"}
      end
    end
    @type1=params[:type1]
    @type2=params[:type2]
    @brand=params[:brand]
    @first=params[:first]
    @second=params[:second]
    @third=params[:third]
    @author=params[:author]
    @title=params[:title]
    @begintime=params[:begintime]
    @endtime=params[:endtime]
    @page=params[:page]
    @order=params[:order]
    @beginnum=params[:beginnum]
    @allnum=params[:allnum]
    @leixing=params[:leixing]
    @zhuangtai=params[:zhuangtai]
    @source=params[:source]


    #大分类 -- type1
    @type1list = ProductCategory.find(:all, :conditions => ["parent_id = ? ", 1])

    #所有编辑 -- user
    @alledit = User.find_by_sql("SELECT id,rname FROM radmin_users where role like '%134%' or role like '%138%' or role like '%139%'")

    #小分类 -- type2
    if @type1 && @type1 != '0'
      @type2list = ProductCategory.find(:all, :conditions => ["parent_id = ?", params[:type1]])
    end

    #品牌 -- brand
    if @type2 && @type2 != '0'
      t2 = ProductCategory.find(@type2)
      @brandlist = t2.brands
    end

    #文章大分类 -- first
    @categories = ArticleTag.find(:all ,:conditions =>["TAGFATHERID = ? and TAGESTATE = '0'",14025])


    #文章小分类 -- second
    if @first && @first != '0'
      s = ArticleTag.find(@first)
      @secondcategories = s.sonlist
    end

    #文章第三类 -- third
    if @second && @second != '0'
      s = ArticleTag.find(@second)
      @thirdcategories = s.sonlist
    end
    d = Date.today
    datet = d<<3
    if @begintime && @begintime != ''

    else
      @begintime = datet.strftime("%Y-%m-%d")
    end
    #组合搜索条件
    conditions = []
    conditions << "(STATE<>'-1' or STATE is null)"
    conditions << "shop_merchant_id = 0"
    conditions << "BRAND_ID = #{@brand}" if @brand && @brand != '0'
    conditions << "FIRSTCATEGORY = '#{@first}'" if @first && @first != '0'
    conditions << "SECONDCATEGORY = '#{@second}'" if @second && @second != '0'
    conditions << "THIRDCATEGORY = '#{@third}'" if @third && @third != '0'
    if !params[:author].nil? && params[:author] != '0'
      user = User.find(params[:author])
      if user.editer_id.nil? && user.editer_id != '0'
        conditions << "EDITPEOPLE = '#{user.id}'"
      else
        conditions << "(ADDPEOPLE='#{user.editer_id}' or EDITPEOPLE = '#{user.id}')"
      end
    end
    conditions << "TITLE like '%#{@title.strip}%'" if @title && @title != ''

    if @begintime && @begintime != ''
      conditions << "CREATETIME >= '#{@begintime}'"
    end

    case @source.to_i
    when 1
      conditions << "SOURCE = '原创'"
    when 2
      conditions << "SOURCE = '转载'"
    when 3
      conditions << "SOURCE = '网友来稿'"
    when 4
      conditions << "(SOURCE = '原创' or SOURCE = '原创[带版权]')"
    when 5
      conditions << "SOURCE = '原创[带版权]'"
    else

    end

    conditions << "CREATETIME <= '#{@endtime}'" if @endtime && @endtime != ''
    conditions << "STATE = '#{@zhuangtai}'" if @zhuangtai && @zhuangtai != ''
    conditions << "CITYORDERBY = '#{@leixing}'" if @leixing && @leixing != ''

    if @third && @third != '0'
      orderstr = ' THIRDORDERID desc,ID desc '
    elsif @second && @second != '0'
      orderstr = ' SECONDORDERID desc,ID desc '
    elsif @first && @first != '0'
      orderstr = ' FIRSTORDERID desc,ID desc '
    else
      orderstr = ' ID desc '
    end

    #搜索
    if @beginnum && @allnum
      @articles = Article.find(:all,
        :conditions => conditions.join(" and "),
        :order => orderstr,
        :total_entries => Article.total_entries,
        :offset => @beginnum,
        :limit => @allnum)
    else
      if @third != '0' && (ArticleTag.all_categories.map(&:TAGID).member? @second.to_i)
        conditions.delete("THIRDCATEGORY = '#{@third}'")
        conditions << "production_category_id = #{@third}"
        @articles = Article.paginate  :page => params[:page], :per_page => @page_size,
          :joins =>"join articles_production_categories on HEJIA_ARTICLE.id=articles_production_categories.article_id",
          :conditions => conditions.join(" and "),
          :order => orderstr
      else
        @articles = Article.paginate  :page => params[:page], :per_page => @page_size,
          :conditions => conditions.join(" and "),
          :order => orderstr
      end
    end
  end
  
  def merchant_articles
    unless params[:page_size].blank?
      cookies["page_size"] = {:value => params[:page_size], :domain=>".51hejia.com"}
      @page_size = params[:page_size]
    else
      unless cookies[:page_size].blank?
        @page_size = cookies[:page_size]
      else
        @page_size = 20
        cookies["page_size"] = {:value => params[:page_size], :domain=>".51hejia.com"}
      end
    end
    @type1=params[:type1]
    @type2=params[:type2]
    @brand=params[:brand]
    @first=params[:first]
    @second=params[:second]
    @third=params[:third]
    @author=params[:author]
    @title=params[:title]
    @begintime=params[:begintime]
    @endtime=params[:endtime]
    @page=params[:page]
    @order=params[:order]
    @beginnum=params[:beginnum]
    @allnum=params[:allnum]
    @leixing=params[:leixing]
    @zhuangtai=params[:zhuangtai]
    @source=params[:source]


    #大分类 -- type1
    @type1list = ProductCategory.find(:all, :conditions => ["parent_id = ? ", 1])

    #所有编辑 -- user
    @alledit = User.find_by_sql("SELECT id,rname FROM radmin_users where role like '%134%' or role like '%138%' or role like '%139%'")

    #小分类 -- type2
    if @type1 && @type1 != '0'
      @type2list = ProductCategory.find(:all, :conditions => ["parent_id = ?", params[:type1]])
    end

    #品牌 -- brand
    if @type2 && @type2 != '0'
      t2 = ProductCategory.find(@type2)
      @brandlist = t2.brands
    end

    #文章大分类 -- first
    @categories = ArticleTag.find(:all ,:conditions =>["TAGFATHERID = ? and TAGESTATE = '0'",14025])


    #文章小分类 -- second
    if @first && @first != '0'
      s = ArticleTag.find(@first)
      @secondcategories = s.sonlist
    end

    #文章第三类 -- third
    if @second && @second != '0'
      s = ArticleTag.find(@second)
      @thirdcategories = s.sonlist
    end
    d = Date.today
    datet = d<<3
    if @begintime && @begintime != ''

    else
      @begintime = datet.strftime("%Y-%m-%d")
    end
    #组合搜索条件
    conditions = []
    conditions << "(STATE<>'-1' or STATE is null)"
    conditions << "shop_merchant_id != 0"
    conditions << "BRAND_ID = #{@brand}" if @brand && @brand != '0'
    conditions << "FIRSTCATEGORY = '#{@first}'" if @first && @first != '0'
    conditions << "SECONDCATEGORY = '#{@second}'" if @second && @second != '0'
    conditions << "THIRDCATEGORY = '#{@third}'" if @third && @third != '0'
    if !params[:author].nil? && params[:author] != '0'
      user = User.find(params[:author])
      if user.editer_id.nil? && user.editer_id != '0'
        conditions << "EDITPEOPLE = '#{user.id}'"
      else
        conditions << "(ADDPEOPLE='#{user.editer_id}' or EDITPEOPLE = '#{user.id}')"
      end
    end
    conditions << "TITLE like '%#{@title.strip}%'" if @title && @title != ''

    if @begintime && @begintime != ''
      conditions << "CREATETIME >= '#{@begintime}'"
    end

    case @source.to_i
    when 1
      conditions << "SOURCE = '原创'"
    when 2
      conditions << "SOURCE = '转载'"
    when 3
      conditions << "SOURCE = '网友来稿'"
    when 4
      conditions << "(SOURCE = '原创' or SOURCE = '原创[带版权]')"
    when 5
      conditions << "SOURCE = '原创[带版权]'"
    else

    end

    conditions << "CREATETIME <= '#{@endtime}'" if @endtime && @endtime != ''
    conditions << "STATE = '#{@zhuangtai}'" if @zhuangtai && @zhuangtai != ''
    conditions << "CITYORDERBY = '#{@leixing}'" if @leixing && @leixing != ''

    if @third && @third != '0'
      orderstr = ' THIRDORDERID desc,ID desc '
    elsif @second && @second != '0'
      orderstr = ' SECONDORDERID desc,ID desc '
    elsif @first && @first != '0'
      orderstr = ' FIRSTORDERID desc,ID desc '
    else
      orderstr = ' ID desc '
    end

    #搜索
    if @beginnum && @allnum
      @articles = Article.find(:all,
        :conditions => conditions.join(" and "),
        :order => orderstr,
        :total_entries => Article.total_entries,
        :offset => @beginnum,
        :limit => @allnum)
    else
      if @third != '0' && (ArticleTag.all_categories.map(&:TAGID).member? @second.to_i)
        conditions.delete("THIRDCATEGORY = '#{@third}'")
        conditions << "production_category_id = #{@third}"
        @articles = Article.paginate  :page => params[:page], :per_page => @page_size,
          :joins =>"join articles_production_categories on HEJIA_ARTICLE.id=articles_production_categories.article_id",
          :conditions => conditions.join(" and "),
          :order => orderstr
      else
        @articles = Article.paginate  :page => params[:page], :per_page => @page_size,
          :conditions => conditions.join(" and "),
          :order => orderstr
      end
    end
  end

  #按照文章最后编辑人进行查找
  def article_people
    unless params[:p_size].blank?
      cookies["p_size"] = {:value => params[:p_size], :domain=>".51hejia.com"}
      @p_size = params[:p_size]
    else
      unless cookies[:p_size].blank?
        @p_size = cookies[:p_size]
      else
        @p_size = 20
        cookies["p_size"] = {:value => params[:p_size], :domain=>".51hejia.com"}
      end
    end
    @author=params[:author]
    @begintime=params[:begintime]
    @endtime=params[:endtime]
    @beginnum=params[:beginnum]
    @allnum=params[:allnum]
    @editbegintime=params[:editbegintime]
    @editendtime=params[:editendtime]

    @alledit = User.find_by_sql("SELECT id,rname FROM radmin_users where role like '%134%' or role like '%138%' or role like '%139%'")
    d = Date.today
    datet = d<<3
    if @begintime && @begintime != ''
    else
      @begintime = datet.strftime("%Y-%m-%d")
    end

    conditions = []
    conditions << "(STATE<>'-1' or STATE is null)"
    conditions << "CREATETIME >= '#{@begintime}'" if @begintime && @begintime != ''
    conditions << "CREATETIME <= '#{@endtime}'" if @endtime && @endtime != ''
    conditions << "LASTMODIFYTIME >= '#{@editbegintime}'" if @editbegintime && @editbegintime != ''
    conditions << "LASTMODIFYTIME <= '#{@editendtime}'" if @editendtime && @editendtime != ''
    if !params[:author].nil? && params[:author] != '0'
      user = User.find(params[:author])
      conditions << "(CHECKPEOPLE = '#{user.id}' or EDITPEOPLE = '#{user.id}')"
    end
    #搜索
    if @beginnum && @allnum
      @articles = Article.find(:all,
        :conditions => conditions.join(" and "),
        :order => orderstr,
        :total_entries => Article.total_entries,
        :offset => @beginnum,
        :limit => @allnum)
    else
      @articles = Article.paginate  :page => params[:page], :per_page => @p_size,
        :conditions => conditions.join(" and "),
        :order => ' ID desc '
    end
  end

  #article_list页面的批量删除
  def delete_all
    dele = params[:dele]
    unless params[:dele].nil?
      dele = dele[0,dele.length-1]
      Article.update_all("STATE = '-1'", "id in (#{dele})")
    end
    article_ids=dele.split(",")
    article_ids.each do |article_id|
      PUBLISH_CACHE.set("key_publish_article_show_content_20090512_#{article_id}", nil, 1)
    end

    redirect_to :back

=begin
    redirect_to :action => "index",
      :type1 => params[:type1],
      :type2 => params[:type2],
      :brand => params[:brand],
      :first => params[:first],
      :second => params[:second],
      :third => params[:third],
      :author => params[:author],
      :title => params[:title],
      :begintime => params[:begintime],
      :endtime => params[:endtime],
      :page => params[:page],
      :order => params[:order],
      :beginnum => params[:beginnum],
      :allnum => params[:allnum],
      :leixing => params[:leixing],
      :zhuangtai => params[:zhuangtai]
=end
  end

  #article_people页面的批量删除----（功能取消）
  def dele_all
    dele = params[:dele]
    unless params[:dele].nil?
      dele = dele[0,dele.length-1]
      Article.update_all("STATE = '-1'", "id in (#{dele})")
    end

    redirect_to :action => "article_people",
      :author => params[:author],
      :begintime => params[:begintime],
      :endtime => params[:endtime],
      :page => params[:page],
      :beginnum => params[:beginnum],
      :allnum => params[:allnum]
  end

  #删除后保留搜索条件返回搜索页
  def delete
    delid = params[:delid]
    if delid
      article = Article.find(delid.to_i)
      article.STATE = '-1'
      article.save
    end

    redirect_to :action => "index",
      :type1 => params[:type1],
      :type2 => params[:type2],
      :brand => params[:brand],
      :first => params[:first],
      :second => params[:second],
      :third => params[:third],
      :author => params[:author],
      :title => params[:title],
      :begintime => params[:begintime],
      :endtime => params[:endtime],
      :page => params[:page],
      :order => params[:order],
      :beginnum => params[:beginnum],
      :allnum => params[:allnum],
      :leixing => params[:leixing],
      :zhuangtai => params[:zhuangtai]
  end

  #按照分类设置排序码
  def setorder
    typenum = params[:typenum]
    articleid = params[:articleid]
    ordervalue = params[:ordervalue]

    art = Article.find(articleid)

    if typenum == '1'
      art.FIRSTORDERID = ordervalue
    elsif typenum == '2'
      art.SECONDORDERID = ordervalue
    elsif typenum == '3'
      art.THIRDORDERID = ordervalue
    end

    art.save

    redirect_to :action => "index",
      :type1 => params[:type1],
      :type2 => params[:type2],
      :brand => params[:brand],
      :first => params[:first],
      :second => params[:second],
      :third => params[:third],
      :author => params[:author],
      :title => params[:title],
      :begintime => params[:begintime],
      :endtime => params[:endtime],
      :page => params[:page],
      :order => params[:order],
      :beginnum => params[:beginnum],
      :allnum => params[:allnum],
      :leixing => params[:leixing],
      :zhuangtai => params[:zhuangtai]
  end

  #生成标签入口
  def generate_article
    @brand=params[:brand]
    @first=params[:first]
    @second=params[:second]
    @third=params[:third]
    @author=params[:author]
    @begintime=params[:begintime]
    @endtime=params[:endtime]
    @order=params[:order]
    @beginnum=params[:beginnum]
    @allnum=params[:allnum]
    @buju=params[:buju]
    @generatetype=params[:generatetype]
    @ids = ''
    #new
    @title = params[:title]
    #end
    if params[:article] && params[:article][:selected_ids]
      params[:article][:selected_ids].each do |id|
        @ids = @ids + id+' '
      end
      @ids = @ids.strip
      @ids = @ids.gsub(' ', ',')
    end
  end

  #文章分类迁移
  def changetype

    if request.post?
      first = params[:first] ||= '0'
      second = params[:second] ||= '0'
      third = params[:third] ||= '0'

      first2 = params[:first2] ||= '0'
      second2 = params[:second2] ||= '0'
      third2 = params[:third2] ||= '0'

      authorname = params[:authorname]

      user = User.find(:first,:conditions => "rname = '#{authorname}'")

      if !user.nil?
        Article.updatetype(first,second,third,first2,second2,third2,user.id)

        render :text => '成功'
      else
        Article.updatetype(first,second,third,first2,second2,third2,nil)
        render :text => '非用户导入成功'
      end
    end
  end

  begin
    require 'hpricot'
  rescue LoadError
  end

  #测试hpricot
  def test
    d = DecoReview.find(:first,:order =>"id desc")

    render :text => d.company_id
  end

  def water_mark_edit
    @image = params[:image]
    @id = params[:id]
    render :layout => false
  end

  def water_mark_create

    @id = params[:id]
    image = params[:image].to_s
    logo = params[:logo].to_s
    left = params[:left].to_i
    top = params[:top].to_i
    width = params[:width].to_i
    height = params[:height].to_i
    image_path = File.join(RAILS_ROOT, 'public', image)
    logo_path = File.join(RAILS_ROOT, 'public', logo)
    p "============================"
    p "image_path is #{image_path}"
    p "image_path #{image_path}"
    p "logo_path #{logo_path}"
    p "width #{width}"
    p "height #{height}"
    p "left #{left}"
    p "top #{top}"
    p "============================"
    Binary.manual_water_mark image_path, logo_path, width, height, left, top
    redirect_to :controller => 'article', :action => 'article_collect_add', :id => @id
  end

  def article_collect_add
    unless params[:id].blank?
      @act = "collect"
      @id = params[:id]
      @article = ArticleInfo.find(@id)
      @article.update_attribute(:added_status , 1)
      @title = @article.title
      @content = @article.content
      doc = Hpricot(@content)
      @images = ((doc/"img").map {|f| f.attributes["src"]}).compact
      @image_file = @article.image unless @article.image.blank?
      render :action => 'new'
    else
      redirect_to :back
    end

  end
  def article_collect_show
    unless params[:id].blank?
      @id = params[:id]
      @article = ArticleInfo.find(@id)
      render :layout => false
    else
      redirect_to :back
    end
  end
  #  article采集
  def article_collect
    conditions_array = []
    conditions_array << " added_status = 0 "
    unless params[:search].blank?
      conditions_array << " title like '%#{params[:search]}%' "
      @search = params[:search]
    end
    unless params[:content].blank?
      conditions_array << " content like '%#{params[:content]}%' "
      @content = params[:content]
    end
    #将查询的时间写入COOKIE
    unless params[:begin_time].blank?
      cookies["article_begintime"] = {:value => params[:begin_time], :domain=>".51hejia.com"}
      @begin_time = params[:begin_time]
    else
      @begin_time = cookies[:article_begintime]
    end

    unless @begin_time.blank?
      conditions_array << "  created_at  >= '#{@begin_time}' "
    end
    #将查询的时间写入COOKIE
    unless params[:end_time].blank?
      cookies["article_endtime"] = {:value => params[:end_time], :domain=>".51hejia.com"}
      @end_time = params[:end_time]
    else
      @end_time = cookies[:article_endtime]
    end
    unless @end_time.blank?
      conditions_array << " created_at <= '#{@end_time}' "
    end

    # :order => "created_at desc",
    #    hash = {:page => params[:page], :per_page => 100, :total_entries => ArticleInfo.total_entries, :select => 'id,title,created_at', :order => 'id desc'}
    #    p "-----------------------------"
    #    p hash
    #    p "-----------------------------"
    #    conditions = conditions_array.join("and")
    #    hash.merge!(:conditions => conditions)
    #
    #    @articles = ArticleInfo.paginate hash
    @page = params[:page]
    if params[:page].to_s==""
      @page = nil
    end
    key_total_count ="article_article_collect_count_#{params[:search]}_#{params[:content]}_#{Time.now.strftime('%Y%m%d%H')}_#{@begin_time}_#{@end_time}"
    if CACHE.get(key_total_count).nil?
      articlecount = ArticleInfo.count(:all,:select => 'id',:conditions =>conditions_array.join("and"))
      CACHE.set(key_total_count, articlecount)
    else
      articlecount = CACHE.get(key_total_count)
    end
    @articles = ArticleInfo.paginate :page => @page, :per_page => 100,:total_entries=>articlecount,
      :select => 'id,title,created_at',
      :conditions => conditions_array.join(" and "),
      :order => 'id desc'
  end


  #通过url到备用库搜
  def getfromurl
    url = params[:url]
    if request.post?
      #根据url搜索
      if url && url != ''
        url = url.lstrip
        result = ArticleUrl.find(:all,:conditions => "url = '#{url}' and is_fetched = '1'")
        #没有找到
        if result.size == 0
          result2 = ArticleUrl.find(:all,:conditions => "url = '#{url}' and is_fetched = '0'")
          #查看是否已经提交处理,没处理保存ArticleUrl并邮件通知小能
          if result2.size == 0
            arturl = ArticleUrl.new
            arturl.url = url
            arturl.is_fetched = 0
            arturl.created_at = Time.now
            arturl.updated_at = Time.now
            arturl.save

            OrderMailer.deliver_sent(url)
          else
            #已做过相应操作
          end
          @message = "已经发送邮件通知抓取"+url+"，请耐心等待，过段时间再来搜索"
          #找到,去找相应文章内容
        else
          infoid = result[0].id
          artinfo = ArticleInfo.find(:all,:conditions => "article_urls_id = '#{infoid}'")
          #找到内容，跳转到new
          if artinfo.size > 0
            @title = artinfo[0].title
            @content = artinfo[0].content

            render :action => "new"
          else
            @message = "没有找到articleinfo内容"
          end
        end
      end
    end
  end

  #一级品牌下拉列表
  def select_type2
    @tagsonlist = ProductCategory.find(:all, :conditions => ["parent_id = ?", params[:type1]])
    render :partial => "select_type2"
  end

  #二级品牌下拉列表
  def select_brand
    p = ProductCategory.find(params[:type2])
    @brandselectlist = p.brands
    render :partial => "select_brand"
  end

  #一级分类下拉列表
  def select_second
    if params[:first] == '42092'
      @secondlist = ArticleTag.all_categories
    elsif params[:first] != '0'
      s = ArticleTag.find(params[:first])
      @secondlist = s.sonlist
    end
    render :partial => @secondlist ? "select_second" : "select_zero"
  end

  #二级分类下拉列表
  def select_third
    if params[:second] != '0'
      if ArticleTag.all_categories.map(&:TAGID).member? params[:second].to_i
        @thirdlist = ProductionCategory.find :all,:conditions =>["tag_id = ?",params[:second].to_i]
        params[:show] ? (render :partial => "select_third") : (render :partial =>'select_third_brand')
      else
        s = ArticleTag.find(params[:second])
        @thirdlist = s.sonlist
        render :partial => "select_third"
      end
    else
      render :partial => "select_zero"
    end
  end

  #文章小分类下拉(备用)
  def select_second2
    s = ArticleTag.find(params[:first])
    @secondlist = s.sonlist
    render :partial => "select_second2"

  end

  #文章三级分类(备用)
  def select_third2
    s = ArticleTag.find(params[:second])
    @thirdlist = s.sonlist
    render :partial => "select_third2"
  end

  # 油工关键词
  def paint_keywords
    @article = Article.find(params[:article_id]) unless params[:article_id].nil?
    if params[:first] == '61136'
      render :partial => "paint_keywords", :locals => {:article => @article}
    else
      render :text => ""
    end
  end

  #ajax文章重名检查
  def checkrename
    @as = Article.find(:all, :conditions => ["TITLE = ? and STATE <> '-1' ", params[:articletitle]])
    render :partial => "checkrename"
  end

  def list_process
    params[:article][:selected_ids] ||= []
  end

  def expire_new
    expire_fragment(:controller => "article", :action => "new")
  end

  def new

    #大分类 -- type1


    #  commented by chandle is move to ProductCategory 2009-06-08 17:24:14w
    # ＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋
    # @type1list = ProductCategory.find(:all, :conditions => ["parent_id = ?", 1])
    # ＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋

    #小分类 -- type2
    #  commented by chandle is not usefull anymore 2009-06-08 17:24:14
    # ＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋
    # com
    # if @type1 && @type1 != '0'
    #   @type2list = ProductCategory.find(:all, :conditions => ["parent_id = ?", params[:type1]])
    # end
    # ＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋

    #品牌 -- brand
    #  commented by chandle is not usefull anymore 2009-06-08 17:24:14
    # ＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋
    # if @type2 && @type2 != '0'
    #   t2 = ProductCategory.find(@type2)
    #   @brandlist = t2.brands
    # end
    # ＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋

    #文章大分类 -- first


    #  commented by chandle is move to ArticleTag 2009-06-08 17:24:14w
    # ＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋
    # @categories = ArticleTag.find(:all ,:conditions =>["TAGFATHERID = ? and TAGESTATE = '0'",14025])
    # ＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋

    #文章小分类 -- second


    # commented by chandle is not usefull anymore 2009-06-08 17:24:19
    # ＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋
    # if @first && @first != '0'
    #   s = ArticleTag.find(@first)
    #   @secondcategories = s.sonlist
    # end
    # ＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋

    #    @articleFirst = ArticleTag.find(:all,
    #    :conditions=>["TAGFATHERID=:tagf and TAGESTATE<>'-1'",{:tagf=>14025}])
    # ++++++++++++++++++++
    # @publishTime = Time.now.strftime("%Y-%m-%d").to_s
    # ++++++++++++++++++++

    # commented by chandle is not usefull anymore 2009-06-08 17:24:19
    # ++++++++++++++++++++
    # @aft = ArticleTag.find(:all,:conditions=>["TAGID in (31871,35762,35763,35764,35765,35766,35767,35768,35769,35770,35771,35772)"])
    # @at = ArticleTag.find(:all, :conditions=>["TAGFATHERID in (31871,35762,35763,35764,35765,35766,35767,35768,35769,35770,35771,35772)"])
    # ++++++++++++++++++++
    if staff_logged_in?
      @user = current_staff

      if @user.role.split(',').include?("134")
        @user.rname = "责任编辑："+@user.rname.to_s
      elsif @user.role.split(',').include?("139")
        @user.rname = "实习编辑："+@user.rname.to_s
      end
    end
  end


  # TODO hejiaindex更新 可以放在文章操作后 ob或after方式，具体视需求而定
  def create
    if request.post?
      @state = params[:mark]

      if !params[:content].blank? && params[:water_mark] == '1'
        (@images = (Hpricot(params[:content]) / "img").map { |f| f["src"] }).compact!
        @images.each do |image|
          image_file = File.join RAILS_ROOT, 'public', image
          watermark_suffix = case params[:water_size] when '1' then '_b' when '2' then '_s' end
          watermark_file   = File.join RAILS_ROOT, 'public/', "images/watermark_logo#{watermark_suffix}.gif"
          Binary.water_mark image_file, watermark_file, @state
        end
      end

      @checkbrand = params[:checkbrand]
      articlestate = params[:state]
      articlestate = "2" if articlestate.blank?

      #      'STATE' => articlestate,
      hash = {
        'KEYWORD1' => params[:keyword1],
        'KEYWORD2' => params[:keyword2],
        'AUTHOR' => params[:author],
        'SOURCE' => params[:source],
        'insert_summary' => params[:insert_summary].to_i,
        'SUMMARY' => params[:summary],
        'STATE' => '2',
        'PROVINCE1'  =>  32540,
        'PROVINCE2'  =>  32558,
        'FIRSTORDERID' => '0',
        'SECONDORDERID' => '0',
        'THIRDORDERID' => '0',
        #    文章咨询分类
        'FIRSTCATEGORY'  =>  params[:first],
        'SECONDCATEGORY'  =>  params[:second],
        'THIRDCATEGORY'  =>  params[:third],
        'CITYORDERBY' => params[:articletype],
        'LASTMODIFYTIME' => Time.now,
        'CREATETIME' => Time.now,
        'TITLE' => params[:title],
        'CHECK_BRAND' => params[:checkbrand]}

      @status = true
      unless params[:act].blank?
        hash.merge!('FIRSTORDERID' => -1,'SECONDORDERID' => -1, 'THIRDORDERID' => -1)
      end
      @article =Article.new(hash)

      if strip(params["image"][:uploaded_data].to_s) != ""

        @image = ArticleMain.new(params[:image])
        @status = @image.save
        @article.IMAGENAME = @image.filename
      elsif !params["image_file"].blank?
        @article.IMAGENAME = params["image_file"]
      end
      if @status

        articlecontent = ArticleContent.new
        articlecontent.CONTENT=params[:content]
        articlecontent.save
        @article.CONTENTID = articlecontent.id

        if staff_logged_in?
          @article.ADDPEOPLE = current_staff.editer_id
          #统计绩效用radmin用户
          @article.EDITPEOPLE = current_staff.id
        end

        @article.CREATETIME = Time.now
        @article.save

        ## 油工关键词
        unless params[:paint_keywords].blank?
          for pk_id in params[:paint_keywords]
            PaintKeywordArticle.create(:paint_keyword_id => pk_id.to_i, :article_id => @article.ID)
          end
        end

        if !params[:third].nil? && (ArticleTag.all_categories.map(&:TAGID).member? params[:second].to_i)
          @article.production_category_ids = params[:third][:product_category_ids]
        end
        #文章任务量统计
        event = ArticleEvent.find(ARTICLE_ADD_EVENT_ID)
        articlelog = HejiaLog.new
        articlelog.user_id = current_staff.id
        articlelog.event_id = event.id
        articlelog.entity_type = ARTICLE_ADD_ENTITY_TYPE
        articlelog.entity_id = @article.ID
        articlelog.created_at = Time.now
        articlelog.updated_at = Time.now
        articlelog.save
        #
        keywordlist = Array.new
        if !@article.KEYWORD1.nil?&&@article.KEYWORD1.to_s!=''
          puts @article.KEYWORD1
          keywordreplace = @article.KEYWORD1.gsub(",",";")
          puts keywordreplace
          keywordlist = keywordreplace.split(";")
          keywordlist.each do |indexkeyword|
            puts indexkeyword
            temp = HejiaIndexKeyword.find(:first,:conditions =>" name='#{indexkeyword}'")
            if temp.nil?
              temp = HejiaIndexKeyword.new
              temp.name = indexkeyword
              temp.created_at = Time.now
              temp.updated_at = Time.now
              temp.save
            end
            r = Relation.new
            r.entity_id = @article.ID
            r.keyword_id = temp.id
            r.relation_type = 1
            r.created_at = Time.now
            r.save
          end
        end
        if !params[:tagsBox].nil?
          puts params[:tagsBox]
          params[:tagsBox].each do |tags|
            articleTagl = ArticleTagLink.new
            articleTagl.ENTITYID = @article.ID
            articleTagl.LINKTYPE = "article"
            articleTagl.TAGID = tags
            articleTagl.save
          end

        end

        content = @article.article_content.CONTENT
        index   = HejiaIndex.find(:first, :conditions => ["entity_id = ? and entity_type_id = ? and is_valid = ?", @article.id, 1, 1])
        if index.nil?
          index                   = HejiaIndex.new
          index.entity_id         = @article.ID
          index.entity_type_id    = 1
          index.is_valid          = 1
          index.entity_created_at = Time.now
          index.entity_updated_at = Time.now
          index.entity_expired_at = Time.mktime("2035-01-01")
          index.title             = @article.TITLE
          index.description       = content
          # Need parse
          # article.article_content
          images_content          = content.scan(/\<img.*?src\=\"(.*?)\"[^>]*>/i)
          images_content && images_content.first(5).each_with_index do |image, i|
            image_url = "http://image.51hejia.com" + image.to_s
            case i
            when 0;
              index.image_url = image_url
            when 1;
              index.image_url2 = image_url
            when 2;
              index.image_url3 = image_url
            when 3;
              index.image_url4 = image_url
            when 4;
              index.image_url5 = image_url
            end
          end

          domain_prefix = if @article.article_type1 && @article.article_type1.TAGURL=='zhuangxiu'
            "http://d.51hejia.com/"
          elsif @article.article_type1 && @article.article_type1.TAGURL=='pinpaiku'
            "http://b.51hejia.com/"
          else
            "http://www.51hejia.com/"
          end
          tag_url = if @article.article_type1
            @article.article_type1.TAGURL + "/"
          else
            ""
          end
          url_suffix = "#{@article.CREATETIME.strftime("%Y%m%d")}/#{@article.ID}"

          index.url = domain_prefix + tag_url + url_suffix
          index.username = @article.AUTHOR
          index.source   = @article.SOURCE
          index.resume   = @article.SUMMARY
          index.save
        end

        bekeyword = params[:bekeyword]
        if !bekeyword.nil?&&bekeyword.to_s=="1"
          redirect_to :controller => 'wordmanager', :action => 'keyword',:id => @article.id
        else
          redirect_to :action =>'show', :id => @article.id
        end
      else
        flash[:error] = "图片太大无法上传,只允许上传500k图片"
        redirect_to :back
      end
    else
      redirect_to :back
    end
  end

  def show
    #    begin
    #大分类 -- type1
    @article = Article.find(params[:id])
    @type1list = ProductCategory.find(:all, :conditions => ["parent_id = ?", 1])
    #小分类 -- type2
    if @article.PRODUCTSECONDCATEGORY && @article.PRODUCTSECONDCATEGORY.to_s != '0'
      @type2list = ProductCategory.find(:all, :conditions => ["parent_id = ?", @article.PRODUCTFIRSTCATEGORY])
    else
      @type2list = ""
    end

    #品牌 -- brand
    if @article.BRAND_ID && @article.BRAND_ID.to_s != '0'
      t2 = ProductCategory.find(@article.PRODUCTSECONDCATEGORY.to_i)
      @brandlist = t2.brands
    else
      @brandlist=nil
    end

    #文章大分类 -- first
    @categories = ArticleTag.find(:all ,:conditions =>["TAGFATHERID = ? and TAGESTATE = '0'",14025])
    #文章小分类 -- second
    firstcategory = @article.FIRSTCATEGORY.to_i
    if firstcategory == 42092
      @secondcategories = ArticleTag.all_categories
    elsif firstcategory > 0
      @secondcategories = ArticleTag.find(firstcategory).sonlist rescue nil
    end

    #文章小分类 -- third
    if @article.SECONDCATEGORY && @article.SECONDCATEGORY.to_s!='0'
      if ArticleTag.all_categories.map(&:TAGID).member? @article.SECONDCATEGORY.to_i
        @thirdcategories = ProductionCategory.find :all,:conditions =>["tag_id = ?",@article.SECONDCATEGORY.to_i]
      else
        s = ArticleTag.find(@article.SECONDCATEGORY)
        @thirdcategories = s.sonlist
      end
    end

    @articleId = @article.ID
    @aft = ArticleTag.find(:all,:conditions=>["TAGID in (31871,35762,35763,35764,35765,35766,35767,35768,35769,35770,35771,35772)"])
    @at = ArticleTag.find(:all, :conditions=>["TAGFATHERID in (31871,35762,35763,35764,35765,35766,35767,35768,35769,35770,35771,35772)"])
    begin
      doc = Hpricot(@article.article_content.CONTENT)
      @images = ((doc/"img").map {|f| f["src"]}).compact
    rescue
    end
    #    @recordlist = Operatelog.find(:all,:conditions => "objid = #{@article.ID}",:order => "id desc")
  end
  def iframe
    @id=params[:id]
    @article = Article.find(params[:id])
    doc = Hpricot(@article.article_content.CONTENT)
    @images = ((doc/"img").map {|f| f["src"]}).compact
    render :layout => false
  end
  def update
    @status = true
    @article = Article.find(params[:id])
    @article.STATE = params[:state]
    @article.KEYWORD1=params[:keyword1]
    @article.KEYWORD2=params[:keyword2]
    @article.AUTHOR=params[:author]
    @article.SOURCE=params[:source]
    @article.SUMMARY=params[:summary]
    @article.insert_summary=params[:insert_summary].to_i
    #    @article.STATE="0"
    @article.PROVINCE1 = 32540
    @article.PROVINCE2 = 32558
    #    文章咨询分类
    @article.FIRSTCATEGORY = params[:first]
    @article.SECONDCATEGORY = params[:second]
    @article.THIRDCATEGORY = params[:third]
    #    文章品牌分类
    #@article.PRODUCTFIRSTCATEGORY = params[:type1]
    #@article.PRODUCTSECONDCATEGORY = params[:type2]
    #@article.BRAND_ID = params[:brand]
    @article.FIRSTORDERID = params[:FIRSTORDERID]
    @article.SECONDORDERID = params[:SECONDORDERID]
    @article.THIRDORDERID = params[:THIRDORDERID]
    @article.CITYORDERBY = params[:articletype]
    @article.TITLE=params[:title]
    @article.LASTMODIFYTIME=Time.now
    @article.CHECKPEOPLE = current_staff.id
    if !params[:checkbrand].nil?
      @article.CHECK_BRAND = params[:checkbrand]
    end
    @articlecontent = ArticleContent.find(@article.CONTENTID)
    @articlecontent.CONTENT=params[:content]
    #打水印
    @state = params[:mark]
    if  ((!params[:water_mark].blank?) && (params[:water_mark] == '1') && !params[:content].blank?)
      doc = Hpricot(params[:content])
      @images = ((doc/"img").map {|f| f["src"]}).compact
      @images.each do |image|
        full_path = File.join(RAILS_ROOT, 'public/', image)
        watermark_path = File.join(RAILS_ROOT, 'public/', 'images/watermark_logo.png')
        Binary.water_mark full_path, watermark_path
      end unless @images.blank?
    end

    if  ((!@state.blank?)  && !params[:content].blank?)
      doc = Hpricot(params[:content])
      @images = ((doc/"img").map {|f| f["src"]}).compact
      @images.each do |image|
        full_path = File.join(RAILS_ROOT, 'public/', image)
        watermark_path = File.join(RAILS_ROOT, 'public/', 'images/watermark_logo.png')
        Binary.water_mark_state full_path, watermark_path ,@state
      end unless @images.blank?
    end
    #结束打水印
    @articlecontent.update_attributes(params[:articlecontent])
    if strip(params["image"][:uploaded_data].to_s) != ""
      @image = ArticleMain.new(params[:image])
      @status = @image.save
      @article.IMAGENAME = @image.filename
    end

    if !params[:keyword1].nil?&&params[:keyword1].to_s!=''
      str = ""
      keywordplace = params[:keyword1].gsub(",",";")
      keywordlist1 = keywordplace.split(";")
      keywordlist1.each do |indexkeyword|
        temp = HejiaIndexKeyword.find(:first,:conditions =>" name='#{indexkeyword}'")
        if temp.nil?
          temp = HejiaIndexKeyword.new
          temp.name = indexkeyword
          temp.created_at = Time.now
          temp.updated_at = Time.now
          temp.save
        end
        relat = Relation.find(:all,:conditions =>"entity_id=#{@article.ID} and keyword_id=#{temp.id} and relation_type=1 ")
        if relat.size>0
        else
          r = Relation.new
          r.entity_id = @article.ID
          r.keyword_id = temp.id
          r.relation_type = 1
          r.created_at = Time.now
          r.save
        end
        str+=temp.id.to_s+","
      end
      str+="0"
      Relation.delete_all "entity_id=#{@article.ID} and keyword_id not in (#{str}) and relation_type=1"
    end
    @article.update_attributes(params[:article])
    ## 油工关键词
    unless params[:paint_keywords].blank?
      @article.paint_keyword_articles.destroy_all
      for pk_id in params[:paint_keywords]
        PaintKeywordArticle.create(:paint_keyword_id => pk_id.to_i, :article_id => @article.ID)
      end
    end


    if !params[:third].nil? && (ArticleTag.all_categories.map(&:TAGID).member? params[:second].to_i)
      params[:third][:product_category_ids] ||= []
      @article.production_category_ids = params[:third][:product_category_ids]
    else
      @article.production_category_ids = []
    end

    # 对原有异常文章在编辑时同步更新hejiaindex
    hejiaindex = HejiaIndex.find(:first,:conditions =>"entity_id=#{@article.ID} and entity_type_id = 1 ") || HejiaIndex.create(:entity_type_id => 1, :entity_id => @article.ID, :entity_created_at => Time.now, :entity_updated_at => Time.now, :entity_expired_at => Time.mktime("2035-01-01"))
    if !hejiaindex.nil?
      hejiaindex.entity_created_at = @article.CREATETIME if hejiaindex.entity_created_at.nil?
      hejiaindex.entity_updated_at = Time.now
      hejiaindex.entity_expired_at = Time.mktime("2035-01-01")
      hejiaindex.is_valid = 1
      hejiaindex.title = @article.TITLE
      hejiaindex.description =params[:content]

      # Need parse
      # article.article_content
      images_content = params[:content].to_s.scan(/\<img.*?src\=\"(.*?)\"[^>]*>/i)
      images_content && images_content.first(5).each_with_index do |image, i|
        image_url = "http://image.51hejia.com" + image.to_s
        case i
        when 0;
          hejiaindex.image_url = image_url
        when 1;
          hejiaindex.image_url2 = image_url
        when 2;
          hejiaindex.image_url3 = image_url
        when 3;
          hejiaindex.image_url4 = image_url
        when 4;
          hejiaindex.image_url5 = image_url
        end
      end

      domain_prefix = if @article.article_type1 && @article.article_type1.TAGURL=='zhuangxiu'
        "http://d.51hejia.com/"
      elsif @article.article_type1 && @article.article_type1.TAGURL=='pinpaiku'
        "http://b.51hejia.com/"
      else
        "http://www.51hejia.com/"
      end
      tag_url       = if @article.article_type1
        @article.article_type1.TAGURL + "/"
      else
        ""
      end
      url_suffix    = "#{@article.CREATETIME.strftime("%Y%m%d")}/#{@article.ID}"
      hejiaindex.url     = domain_prefix + tag_url + url_suffix

      hejiaindex.username = @article.AUTHOR
      hejiaindex.source   = @article.SOURCE
      hejiaindex.resume = @article.SUMMARY
      hejiaindex.update_attributes(params[:hejiaindex])# params中根本就没有 hejiaindex
    end
    if !params[:tagsBox].nil?
      ArticleTagLink.delete_all "ENTITYID="+params[:id]+" and LINKTYPE='article'"
      params[:tagsBox].each do |tags|
        puts tags
        articleTagl = ArticleTagLink.new
        articleTagl.ENTITYID = params[:id]
        articleTagl.LINKTYPE = "article"
        articleTagl.TAGID = tags
        articleTagl.save
      end
    end
    flash[:error] = "图片太大无法上传,只允许上传500k图片" unless @status

    PUBLISH_CACHE.set("key_publish_article_show_content_20090512_#{@article.ID}",nil)
    PUBLISH_CACHE.set("key_publish_article_show_html_keywords_09102801_#{@article.ID}",nil)

    redirect_to :action =>'show', :id => params[:id]
  end
  def artshow
    article = Article.find(params[:id])
    @arts = article.art
    @title=params[:title]
    @id = params[:id]
    conditions = []
    conditions << "STATE='0'"
    conditions << "TITLE like '%#{@title}%'" if @title && @title != ''
    #搜索，预先读取子记录
    @articles = Article.paginate :page => params[:page], :per_page => 20,
      :conditions => conditions.join(" and "),
      :order => " ID desc "
  end

  def articlelink
    article = Article.find(params[:id])
    @id = params[:id]
    @arts = article.art

    unless params[:artid].blank?
      ArticleTagLink.delete_all "ENTITYID="+params[:id]+" and LINKTYPE='art_art'"
      params[:artid].each { |art_id| ArticleTagLink.create(:ENTITYID => @id, :TAGID => art_id, :LINKTYPE => 'art_art')}
    end
    redirect_to :action =>'artshow', :id => @id
  end

  def proshow
    article = Article.find(params[:id])
    #    @prods = article.prod
    @title=params[:title]
    @id = params[:id]
    conditions = []
    conditions << "is_delete=0"
    conditions << "name like '%#{@title}%'" if @title && @title != ''
    #搜索，预先读取子记录
    @products = Product.paginate :page => params[:page], :per_page => 20,
      :conditions => conditions.join(" and "),
      :order => " id desc "
    #查处已选择的产品
    sql = ArticleTagLink.find(:all,:conditions =>"ENTITYID="+params[:id]+" and LINKTYPE='art_prod'").collect{|t| t.TAGID}.join(',')
    condition = "id in("+sql+")"
    if sql.to_s==""
      @productlink = nil
    else
      @productlink = Product.find(:all,:conditions =>condition)
    end
  end

  def productlink
    @id = params[:id]
    unless params[:prodid].blank?
      ArticleTagLink.delete_all "ENTITYID="+params[:id]+" and LINKTYPE='art_prod'"
      params[:prodid].each do |prod|
        articleProduct = ArticleTagLink.new
        articleProduct.ENTITYID = params[:id]
        articleProduct.TAGID = prod
        articleProduct.LINKTYPE = 'art_prod'
        articleProduct.save
      end
    end

    redirect_to :action =>'proshow', :id => params[:id]
  end


  def delete_art
    @id = params[:id]
    params[:artid]
    ArticleTagLink.delete_all "TAGID in (#{params[:artid].join ","}) and LINKTYPE='art_art'"
    redirect_to :action => :artshow, :id => @id

  end


  def delete_prod
    @id = params[:id]
    params[:prodid]
    ArticleTagLink.delete_all "TAGID in (#{params[:prodid].join ","}) and LINKTYPE='art_prod'"
    redirect_to :action => :proshow, :id => @id
  end

  #审核发布等操作
  def checkarticle
    stype = params[:stype]
    article = Article.find(params[:articleid])
    article.STATE = stype
    article.save

    #记录日志
    #    if(article.FIRSTCATEGORY && article.CITYORDERBY && article.EDITPEOPLE && article.ID)
    #      Operatelog.log(article.ID,article.FIRSTCATEGORY,article.CITYORDERBY,article.EDITPEOPLE,stype.to_i)
    #    end

    redirect_to :action => "index",
      :type1 => params[:type1],
      :type2 => params[:type2],
      :brand => params[:brand],
      :first => params[:first],
      :second => params[:second],
      :third => params[:third],
      :author => params[:author],
      :title => params[:title],
      :begintime => params[:begintime],
      :endtime => params[:endtime],
      :page => params[:page],
      :order => params[:order],
      :beginnum => params[:beginnum],
      :allnum => params[:allnum],
      :leixing => params[:leixing],
      :zhuangtai => params[:zhuangtai]
  end

  #批量审核发布等操作
  def checkarticles
    stype = params[:stype]
    if params[:article] && params[:article][:selected_ids]
      params[:article][:selected_ids].each do |id|
        article = Article.find(id)

        #记录日志
        #        if(article.FIRSTCATEGORY && article.CITYORDERBY && article.EDITPEOPLE && article.ID)
        #          Operatelog.log(article.ID,article.FIRSTCATEGORY,article.CITYORDERBY,article.EDITPEOPLE,stype.to_i)
        #        end
        article.STATE = stype
        article.save
      end
    end
    redirect_to :back

=begin
    redirect_to :action => "index",
      :type1 => params[:type1],
      :type2 => params[:type2],
      :brand => params[:brand],
      :first => params[:first],
      :second => params[:second],
      :third => params[:third],
      :author => params[:author],
      :title => params[:title],
      :begintime => params[:begintime],
      :endtime => params[:endtime],
      :page => params[:page],
      :order => params[:order],
      :beginnum => params[:beginnum],
      :allnum => params[:allnum],
      :leixing => params[:leixing],
      :zhuangtai => params[:zhuangtai]
=end
  end

  #article_people页面的批量发布   ----（方法已经取消）
  def check_article
    stype = params[:stype]
    if params[:article] && params[:article][:selected_ids]
      params[:article][:selected_ids].each do |id|
        article = Article.find(id)

        #记录日志
        #        if(article.FIRSTCATEGORY && article.CITYORDERBY && article.EDITPEOPLE && article.ID)
        #          Operatelog.log(article.ID,article.FIRSTCATEGORY,article.CITYORDERBY,article.EDITPEOPLE,stype.to_i)
        #        end
        article.STATE = stype
        article.save
      end
    end

    redirect_to :action => "article_people",
      :author => params[:author],
      :begintime => params[:begintime],
      :endtime => params[:endtime],
      :page => params[:page],
      :beginnum => params[:beginnum],
      :allnum => params[:allnum]
  end

  #退回
  def backarticle
    @articleid = params[:articleid]
    if request.post?
      article = Article.find(params[:articleid])
      if params[:backreason] && params[:backreason] != ''
        article.BACKREASON = params[:backreason]
      end
      article.STATE = '-2'
      article.save

      #      #记录日志
      #      if(article.FIRSTCATEGORY && article.CITYORDERBY && article.EDITPEOPLE && article.ID)
      #        Operatelog.log(article.ID,article.FIRSTCATEGORY,article.CITYORDERBY,article.EDITPEOPLE,-2)
      #      end

      render :text => "退回成功"
    end
  end

  #非文章的索引，提供编辑生成页面
  def siteindex
    @etype = params[:etype] #类型 ["0","1文章","2博客","3论坛","4图片","5产品","6问吧"]
    @keyword = params[:keyword]

    conditions = []
    conditions << " is_valid = '1' and entity_type_id <> '1'"
    conditions << " entity_type_id = '#{@etype}' " if @etype && @etype != ''
    conditions << " title like '%#{@keyword}%' " if @keyword && @keyword != ''

    @resultlist = HejiaIndex.paginate:page => params[:page], :per_page => 20,
      :conditions => conditions.join(" and "),
      :order => 'id desc'

  end

  #生成非文章索引
  def generate_other
    @buju = params[:buju]
    @ids = ''
    if params[:article] && params[:article][:selected_ids]
      params[:article][:selected_ids].each do |id|
        @ids = @ids + id+' '
      end
      @ids = @ids.strip
      @ids = @ids.gsub(' ', ',')
    end
  end

  #按名字生成非文章索引
  def generate_other_name
    @buju = params[:buju]
    #new
    @generatetype = params[:generatetype]
    @etype = params[:etype]
    @beginnum=params[:beginnum]
    @allnum=params[:allnum]
    @keyword = params[:keyword]
    #end
  end

  #回收站列表
  def deletelist
    @type1=params[:type1]
    @type2=params[:type2]
    @brand=params[:brand]
    @first=params[:first]
    @second=params[:second]
    @third=params[:third]
    @author=params[:author]
    @title=params[:title]
    @begintime=params[:begintime]
    @endtime=params[:endtime]
    @page=params[:page]
    @order=params[:order]
    @beginnum=params[:beginnum]
    @allnum=params[:allnum]
    @leixing=params[:leixing]
    @zhuangtai=params[:zhuangtai]

    #大分类 -- type1
    @type1list = ProductCategory.find(:all, :conditions => ["parent_id = ? ", 1])

    #小分类 -- type2
    if @type1 && @type1 != '0'
      @type2list = ProductCategory.find(:all, :conditions => ["parent_id = ?", params[:type1]])
    end

    #品牌 -- brand
    if @type2 && @type2 != '0'
      t2 = ProductCategory.find(@type2)
      @brandlist = t2.brands
    end

    #文章大分类 -- first
    @categories = ArticleTag.find(:all ,:conditions =>["TAGFATHERID = ? and TAGESTATE = '0'",14025])

    #文章小分类 -- second
    if @first && @first != '0'
      s = ArticleTag.find(@first)
      @secondcategories = s.sonlist
    end

    #文章第三类 -- third
    if @second && @second != '0'
      s = ArticleTag.find(@second)
      @thirdcategories = s.sonlist
    end

    #组合搜索条件
    conditions = []

    conditions << "STATE='-1'"
    conditions << "BRAND_ID = #{@brand}" if @brand && @brand != '0'
    conditions << "FIRSTCATEGORY = '#{@first}'" if @first && @first != '0'
    conditions << "SECONDCATEGORY = '#{@second}'" if @second && @second != '0'
    conditions << "THIRDCATEGORY = '#{@third}'" if @third && @third != '0'
    conditions << "(exists (select 1 from HEJIA_USER_BBS where ADDPEOPLE=USERBBSID and USERBBSNAME like '%#{@author.strip}%') or exists (select 1 from radmin_users where EDITPEOPLE=id and rname like '%#{@author.strip}%'))" if @author && @author != ''
    conditions << "TITLE like '%#{@title.strip}%'" if @title && @title != ''
    conditions << "CREATETIME >= '#{@begintime}'" if @begintime && @begintime != ''
    conditions << "CREATETIME <= '#{@endtime}'" if @endtime && @endtime != ''
    conditions << "STATE = '#{@zhuangtai}'" if @zhuangtai && @zhuangtai != ''
    conditions << "CITYORDERBY = '#{@leixing}'" if @leixing && @leixing != ''

    if @third && @third != '0'
      orderstr = ' THIRDORDERID desc,ID desc '
    elsif @second && @second != '0'
      orderstr = ' SECONDORDERID desc,ID desc '
    elsif @first && @first != '0'
      orderstr = ' FIRSTORDERID desc,ID desc '
    else
      orderstr = ' ID desc '
    end

    #搜索
    if @beginnum && @allnum


      @articles = Article.find(:all,:select=>"ID,THIRDORDERID,SECONDORDERID,FIRSTORDERID,TITLE,EDITPEOPLE,CREATETIME,ADDPEOPLE,STATE",
        :conditions => conditions.join(" and "),
        :order => orderstr,
        :total_entries => Article.total_entries,
        :offset => @beginnum,
        :limit => @allnum)
    else

      @articles = Article.paginate :page => params[:page], :per_page => 20,
        :select=>"ID,THIRDORDERID,SECONDORDERID,FIRSTORDERID,TITLE,EDITPEOPLE,CREATETIME,ADDPEOPLE,STATE",
        :conditions => conditions.join(" and "),
        :order => orderstr,
        :include => [:article_type1,:article_author]
    end
  end

  #找回操作
  def checkdelarticle
    stype = params[:stype]
    article = Article.find(params[:articleid])
    article.STATE = stype
    article.save

    #记录日志
    #    if(article.FIRSTCATEGORY && article.CITYORDERBY && article.EDITPEOPLE && article.ID)
    #      Operatelog.log(article.ID,article.FIRSTCATEGORY,article.CITYORDERBY,article.EDITPEOPLE,stype.to_i)
    #    end

    redirect_to :action => "deletelist",
      :type1 => params[:type1],
      :type2 => params[:type2],
      :brand => params[:brand],
      :first => params[:first],
      :second => params[:second],
      :third => params[:third],
      :author => params[:author],
      :title => params[:title],
      :begintime => params[:begintime],
      :endtime => params[:endtime],
      :page => params[:page],
      :order => params[:order],
      :beginnum => params[:beginnum],
      :allnum => params[:allnum],
      :leixing => params[:leixing],
      :zhuangtai => params[:zhuangtai]
  end

  #批量找回操作
  def checkdelarticles
    stype = params[:stype]
    if params[:article] && params[:article][:selected_ids]
      params[:article][:selected_ids].each do |id|
        article = Article.find(id)

        #记录日志
        #        if(article.FIRSTCATEGORY && article.CITYORDERBY && article.EDITPEOPLE && article.ID)
        #          Operatelog.log(article.ID,article.FIRSTCATEGORY,article.CITYORDERBY,article.EDITPEOPLE,stype.to_i)
        #        end

        article.STATE = stype
        article.save
      end
    end

    redirect_to :action => "deletelist",
      :type1 => params[:type1],
      :type2 => params[:type2],
      :brand => params[:brand],
      :first => params[:first],
      :second => params[:second],
      :third => params[:third],
      :author => params[:author],
      :title => params[:title],
      :begintime => params[:begintime],
      :endtime => params[:endtime],
      :page => params[:page],
      :order => params[:order],
      :beginnum => params[:beginnum],
      :allnum => params[:allnum],
      :leixing => params[:leixing],
      :zhuangtai => params[:zhuangtai]
  end

  def editCount
    @begintime=params[:begintime]
    @endtime=params[:endtime]
    d = Date.today
    datet = d<<1
    if !@begintime.nil?
    else
      @begintime = datet
    end
    @userlist = User.find(:all,:conditions => "role like '%139%' or role like '%138' or role like '%134%'")
    #    #组合搜索条件
    idlist = @userlist.collect{|t| t.id}.join(',')
    @id = params[:userid]
    if !@id.nil?
      idlist = @id
    else
    end
    event = ArticleEvent.find(ARTICLE_ADD_EVENT_ID)
    conditions = []
    conditions << "user_id in(#{idlist}) and entity_type=#{ARTICLE_ADD_ENTITY_TYPE} and event_id=#{event.id}"
    if !@endtime.nil?
      conditions << " created_at<='#{@endtime}'"
    end
    if !@begintime.nil?
      conditions << " created_at>='#{@begintime}'"
    end
    @list = HejiaLog.find(:all,:conditions => conditions.join(" and "),:group =>"user_id")
  end

  def editarticlecount
    @userlist = User.find(:all,:conditions => "role like '%139%' or role like '%134%'")
    @begintime=params[:begintime]
    @endtime=params[:endtime]
    @eid = params[:eid]
    if !@eid.nil?
      @user = User.find(@eid)
    else

    end
  end

  #关联品牌
  def linkshow
    @id = params[:art]
    @article = Article.find(@id)
    if @article.FIRSTCATEGORY.to_i == 42092 && @article.SECONDCATEGORY.to_i != 0
      @category = Tag.find(@article.SECONDCATEGORY)
      taggedbrand_ids = TaggedBrand.find(:all, :select => "brand_id",:conditions => ["tag_id = ?", @article.SECONDCATEGORY]).collect{|t| t.brand_id}
      @product_brand = ProductBrand.find(:all, :select => "id,name_zh", :conditions => ["id in (?)",taggedbrand_ids])
      link = ArticleLink.find(:all,:conditions =>["articleid = ? and firstid = ?",@id,@article.SECONDCATEGORY]).collect{|t| t.typeid}
      @brandt = nil
      if link && link.size > 0
        @brandt = ProductBrand.find(:all,:conditions => ["id in(?)",link])
      end
    end
  end
  #保存关联品牌
  def savelink
    @id = params[:articleid]
    ArticleLink.delete_all("articleid=#{@id}")
    if !params[:brand].nil?
      params[:brand].each do |brands|
        link = ArticleLink.new
        link.articleid = @id
        link.typeid = brands
        link.typename = 'brand'
        link.firstid = params[:categoryid]
        link.create_at = Time.now
        link.update_at = Time.now
        link.save
      end
    end
    #保存品牌

    redirect_to:action => "linkshow",
      :art => @id
  end

  def deletelink
    link = params[:id]
    @id = params[:art]
    if !link.nil?&&link.to_s!=""
      ArticleLink.delete_all "typeid in (#{link.join ','}) and articleid=#{@id}"
    end
    redirect_to:action => "linkshow",
      :art => @id
  end

  #显示产品信息
  def relateproduct
    ids = params[:ids]
    products = Product.find(:all,:conditions => "productid in (#{ids})",:select => "productid,name",:order => "id desc")
    @result = ''
    products.each do |p|
      @result = @result + "<a href='http://p.51hejia.com/products/#{p.productid}.html' target='_blank'>#{p.name}</a>，"
    end
    render :layout => false
  end
end
