class WordmanagerController < ApplicationController
    require 'open-uri'
    require 'net/http'
    require 'rexml/document'
  def new
    @id = params[:id]
    @message = params[:message]
    if !@id.nil?&&@id.to_i!=0
      @father = HejiaIndexKeyword.find(@id)
    end
  end
  
  def list
    #组合搜索条件
    @title = params[:title]
    conditions = []
    conditions << "name is not null and name!=''"
    conditions << "keyclass is not null"
    conditions << "name like '%#{@title}%'" if @title && @title != ''
    @list = HejiaIndexKeyword.paginate :page => params[:page], :per_page => 20,
    :conditions => conditions.join(" and "),
    :order => "id desc"
  end
  
  def save
    fatherid = params[:fatherid]
    name = params[:name]
    @kword = HejiaIndexKeyword.find(:first,:conditions =>"name='#{name}'")
    if @kword.nil?
      zhuanqu =params[:zhuangquurl]
      inline = params[:inlineurl]
  #    sameword = params[:sameword]
      hot = params[:hot]
      dayflow = params[:day]
      keytype = params[:keytype]
      keyclass = params[:keyclass]
      level = params[:level]
      time = Time.now
      hejiakey = HejiaIndexKeyword.new
      hejiakey.name = name
      hejiakey.fatherid = fatherid
      hejiakey.zhuanqu = zhuanqu
      hejiakey.inline = inline
      hejiakey.hot = hot
      hejiakey.level = level
      hejiakey.dayflow = dayflow
      hejiakey.keytype = keytype
      hejiakey.keyclass = keyclass
      hejiakey.created_at = time
      hejiakey.updated_at = time
      hejiakey.save
      redirect_to :action => "list"
    else
      redirect_to :action => "new",:id=>fatherid,:message=>"关键词#{name}已存在"
    end
  end
  
  def edit
    @message = params[:message]
    @id = params[:id]
    if !@id.nil?
      @word = HejiaIndexKeyword.find(@id)
    else
      redirect_to :action => "list"
    end
  end
  def update
    name = params[:name]
    @kword = HejiaIndexKeyword.find(:first,:conditions =>"name='#{name}'")
    zhuanqu =params[:zhuangquurl]
    inline = params[:inlineurl]
#    sameword = params[:sameword]
    hot = params[:hot]
    dayflow = params[:day]
    keytype = params[:keytype]
    keyclass = params[:keyclass]
    level = params[:level]
    time = Time.now
    if @kword.nil?
      hejiakey = HejiaIndexKeyword.find(params[:id])
      hejiakey.name = name
      hejiakey.zhuanqu = zhuanqu
      hejiakey.inline = inline
      hejiakey.hot = hot
      hejiakey.dayflow = dayflow
      hejiakey.keytype = keytype
      hejiakey.keyclass = keyclass
      hejiakey.updated_at = time
      hejiakey.update_attributes(params[:hejiakey])
      redirect_to :action=> "edit" ,:id=>params[:id]
    else
      redirect_to :action=> "edit" ,:id=>params[:id],:message=>"#{name}已存在"
    end
  end
  
  def wdel
    HejiaIndexKeyword.delete_all "id in (#{params[:wids]})" unless params[:wids].nil?
    redirect_to :action => "list"
  end
  
  def same
    @message = params[:message]
    @id = params[:id]
    if !@id.nil?
      @word = HejiaIndexKeyword.find(@id)
    else
      redirect_to :action => "list"
    end
  end
  
  def same_save
    fatherid = params[:fatherid]
    name = params[:name]
    puts "======================"
    puts fatherid
    puts name
    puts params[:sameword]
    puts "======================"
    zhuanqu =params[:zhuangquurl]
    inline = params[:inlineurl]
    sameword = params[:sameword]
    hot = params[:hot]
    dayflow = params[:day]
    keytype = params[:keytype]
    keyclass = params[:keyclass]
    level = params[:level]
    time = Time.now
    hejiakey = HejiaIndexKeyword.new
    hejiakey.name = name
    hejiakey.sameword = sameword
    hejiakey.fatherid = fatherid
    hejiakey.zhuanqu = zhuanqu
    hejiakey.inline = inline
    hejiakey.hot = hot
    hejiakey.level = level
    hejiakey.dayflow = dayflow
    hejiakey.keytype = keytype
    hejiakey.keyclass = keyclass
    hejiakey.created_at = time
    hejiakey.updated_at = time
    @kword = HejiaIndexKeyword.find(:first,:conditions =>"name='#{name}'")
    if @kword.nil?
      hejiakey.save
      redirect_to :action => "list"
    else
      redirect_to :action=>"same",
      :id=>params[:sameword],
      :message=>"#{name}关键字已存在"
    end
    
  end
  
  def zhuanqu
    @ids = params[:wids]
  end
  def zhuanqu_save
    @ids = params[:ids]
    zhuanqu = params[:zhuanqu]
    HejiaIndexKeyword.update_all("zhuanqu = '#{zhuanqu}'", "id in (#{@ids})")
    redirect_to :action => "list"
  end
  def truncate(filepath,first,max)
    if filepath.nil? then return end
    chars = filepath.split(//)
    if chars.length>max
      str = chars[first.to_i,max.to_i].to_s
      return str
    else
      return filepath
    end
  end
  def keyword
    @tagids = Array.new
    articleid = params[:id]
    @article = Article.find(articleid)
    @link = Relation.find(:all,:select => "keyword_id",:conditions =>"entity_id=#{@article.ID} and relation_type=1 ")
    for tagid in @link
      @tagids << tagid.keyword_id
    end
    name = @article.article_content.CONTENT
    @keylist = Array.new
#    keepfirst =Hash.new { |h, key| h[key] = [] } #Hash.new
    test = name.gsub(/<.+?>/, '')
    test2 = test.gsub(/&.+?;/,'')
    test1 = test2.gsub("\r\n","")
    test1 = truncate(test1,0,200)
    puts test1
    str = ""
    Net::HTTP.version_1_2
    open("http://api.51hejia.com/rest/format?kw=#{URI.escape(test1)}&format=;") do |http|
      doc = REXML::Document.new(http.read)
      doc.root.each_element do |item|
        str = item.text 
      end
    end
    str1 = str.split(";")
    str1 = str1.uniq
    str1.each do |s|
      temp = HejiaIndexKeyword.find(:first,:conditions =>" name='#{s}' and keyclass is not null")
     
      if !temp.nil?
#        keepfirst[temp.id] << temp.name
        #logger.info "================="+temp.id.to_s+temp.name.to_s+"===================="
        
#        if !keepfirst[temp.id].nil?
#          puts "======================"
#          puts keepfirst[temp.id]
#          puts "======================"
#        else
          @keylist << temp
#        end
      end
    end
    
  end
  
  def link
    articleid = params[:articleid]
    @article = Article.find(articleid)
    ids = params[:wid]
    @keyword = Array.new
    if !@article.nil?
      if !ids.nil?
        ids.each do |wid|
          relat = Relation.find(:all,:conditions =>"entity_id=#{@article.ID} and keyword_id=#{wid} and relation_type=1 ")
          if relat.size>0
          else
            r = Relation.new
            r.entity_id = @article.ID
            r.keyword_id = wid
            r.relation_type = 1
            r.created_at = Time.now
            r.save
          end
        end
      end
      redirect_to :action => 'artkey',:articleid=>@article.ID
    else
      redirect_to :controller => 'article', :action => 'list'
    end
  end
  
  def artkey
    name = params[:name]
    articleid = params[:articleid]
    @article = Article.find(articleid)
    ids= Relation.find(:all,:select => "keyword_id",:conditions =>"entity_id=#{@article.ID} and relation_type=1 ").collect{|t| t.keyword_id}.join(',')
    if !ids.nil?
      @keyword = HejiaIndexKeyword.find(:all,:conditions =>"id in (#{ids})")
    end
    @title = params[:title]
    conditions = []
    conditions << "name is not null and name!=''"
    conditions << "keyclass is not null"
    conditions << "name like '%#{@title}%'" if @title && @title != ''
    @list = HejiaIndexKeyword.paginate :page => params[:page], :per_page => 20,
    :conditions => conditions.join(" and "),
    :order => "id desc"
  end
  
  def deletekey
    articleid = params[:articleid]
    @article = Article.find(articleid)
    wid = params[:wid]
    Relation.delete_all "entity_id=#{@article.ID} and keyword_id =#{wid} and relation_type=1 "
    redirect_to :action => 'artkey',:articleid=>@article.ID
  end
  
  def articlekey
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
    
    @categories = ArticleTag.find(:all ,:conditions =>["TAGFATHERID = ? and TAGESTATE = '0'",14025])
    
    if @first && @first != '0'
      s = ArticleTag.find(@first)
      @secondcategories = s.sonlist
    end
    
    if @second && @second != '0'
      s = ArticleTag.find(@second)
      @thirdcategories = s.sonlist
    end
    
    #组合搜索条件
    conditions = []
    
    conditions << "(STATE<>'-1' or STATE is null)"
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
    key_total_count ="article_article_article_count_count#{params[:title]}_#{params[:page]}_#{params[:first]}_#{params[:second]}_#{params[:third]}_#{Time.now.strftime('%Y%m%d%H')}_#{@begin_time}_#{@end_time}"
    if CACHE.get(key_total_count).nil?
      articlecount = Article.count(:all,:select => 'id',:conditions =>conditions.join(" and "))
      CACHE.set(key_total_count, articlecount)
    else
      articlecount = CACHE.get(key_total_count)
    end
   
   @articles = Article.paginate :page => params[:page], :per_page => 20,:total_entries=>articlecount,
      #      :select=>"ID,THIRDORDERID,SECONDORDERID,FIRSTORDERID,TITLE,EDITPEOPLE,CREATETIME,ADDPEOPLE,STATE",
   :conditions => conditions.join(" and "),
   :order => "ID desc"
    
    
  end
  
end
