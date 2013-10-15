#按tag生成代码
def generatecodebytag options={}
  
  articles = Article.getarticlebytag( :brand => options[:brand],
                                     :first => options[:first], 
                                     :second => options[:second],
                                     :third => options[:third],
                                     :begintime => options[:begintime], 
                                     :endtime => options[:endtime], 
                                     :beginnum => options[:beginnum], 
                                     :allnum => options[:allnum], 
                                     :title =>options[:title],
                                     :order => options[:order]  ) 
  
  return generateruby(:articles => articles,
                      :namelength => options[:namelength],
                      :deslength => options[:deslength],
                      :buju => options[:buju],
                      :classid =>options[:classid])
  
end

#按id生成代码
def generatecodebyid options={}
  
  articles = Article.getarticlebyid(:ids => options[:ids])
  
  return generateruby(:articles => articles,
                      :namelength => options[:namelength],
                      :deslength => options[:deslength],
                      :buju => options[:buju],
                      :classid =>options[:classid])  
end

#整理字符传
def generateruby options={}
  namelength = options[:namelength]
  deslength = options[:deslength]
  classid = options[:classid]
  buju = options[:buju]
  articles = options[:articles]
  
  str = ''
  buju = '21' if buju.nil?
  
  if buju == '21'
    str = str + '<ul>'
    articles.each do |article| 
      url = getarticleurl(article)
      str = str + "<li><a href='"+url+"' target='_blank' title='"+article.TITLE+"'>"+article.TITLE.chars[0,namelength.to_i]+"</a><span class=date>"+article.CREATETIME.strftime('%m-%d')+"</span></li> \n "
    end
    str = str + '</ul>'
  elsif buju == '22'
    str = str + '<ul>'
    articles.each do |article| 
      url = getarticleurl(article)
      str = str + "<li><a href='"+url+"' target='_blank' title='"+article.TITLE+"'>"+article.TITLE.chars[0,namelength.to_i]+"</a></li> \n "
    end
    str = str + '</ul>'
  elsif buju == '23'
    articles.each do |article| 
      url = getarticleurl(article)
      imgurl = getarticleimg(article)
      str = str + "<img src='"+imgurl+"' alt='"+article.TITLE+"'>"
      str = str + '<h4>'
      str = str + "<a href='"+url+"' target='_blank' title='"+article.TITLE+"'>"+article.TITLE.chars[0,namelength.to_i]+"</a></h4> \n "
      str = str + '<p>'+article.SUMMARY.chars[0,deslength.to_i] +'...[<a href='+url+' target=_blank>详细</a>]</p>'
    end  
  elsif buju == '24'
    articles.each do |article| 
      url = getarticleurl(article)
      imgurl = getarticleimg(article)
      str = str + '<h4>'
      str = str + "<a href='"+url+"' target='_blank' title='"+article.TITLE+"'>"+article.TITLE.chars[0,namelength.to_i]+"</a></h4> \n "
      str = str + '<p>'+article.SUMMARY.chars[0,deslength.to_i] +'...[<a href='+url+' target=_blank>详细</a>]</p>'
    end
  elsif buju == '25'
    str = str + ''
    articles.each do |article| 
      url = getarticleurl(article)
      imgurl = getarticleimg(article)
      str = str + '<dl><dt><a href='+url+' target=_blank title='+article.TITLE+'><img src='+imgurl+' alt='+article.TITLE+'  height=97 border=0 /></a></dt>' 
      str = str + '<dd><a href='+url+' target=_blank title='+article.TITLE+'>' +article.TITLE.chars[0,12]+'</a></dd></dl>' 
    end
    #    str = str + ''     
  elsif buju == '26'
    articles.each do |article| 
      url = getarticleurl(article)
      imgurl = getarticleimg(article)
      str = str + '<a href='+url+' target=_blank title='+article.TITLE+'><img src='+imgurl+' alt='+article.TITLE+' border=0 width=150 height=95 /></a>' 
    end
  end
  
  return str
end

#文章url
def getarticleurl(article)
  
  if article.TEMPURL && !article.TEMPURL.blank?
    return article.TEMPURL
  end
  
  domain = 'http://www.51hejia.com/'
  if article.article_type1 && article.article_type1.TAGURL == 'zhuangxiu' 
    domain = 'http://d.51hejia.com/' 
  end  
  if article.article_type1 && article.article_type1.TAGURL != '' 
    domain = domain + article.article_type1.TAGURL + '/' 
  end 
  if article.CREATETIME 
    domain = domain + article.CREATETIME.strftime('%Y%m%d') + '/' 	 
  end 
  domain = domain + article.ID.to_s 
  
  return domain
end

#文章图片地址
def getarticleimg(article)
  img = 'http://d.51hejia.com/api/images/none.gif' 
  if article.IMAGENAME 
    img = 'http://www.51hejia.com/files/hekea/article_img/sourceImage/'+article.IMAGENAME.slice(3,8)+'/'+article.IMAGENAME 
  end  
  
  return img
end

#解析api对应栏目的xml输出
def parse_xml(xml, parameters, end_num = nil)
  parse_xml2 xml, parameters, 0, end_num
end
  
HEJIA_API_PROMOTION_PATTERN = %r'http://api\.51hejia\.com/rest/build/xml/(\d+\.)xml' unless defined?(HEJIA_API_PROMOTION_PATTERN)
HTTP_URL_PATTERN = %r'\Ahttp://'.freeze unless defined?(HTTP_URL_PATTERN)

#解析api对应栏目的xml输出
def parse_xml2(xml, parameters, begin_num = 0, end_num = nil)
  begin_num ||= 0
  limit = end_num && (end_num - begin_num)
  if xml.to_s =~ HEJIA_API_PROMOTION_PATTERN && column_id = $1
    #PUBLISH_CACHE.fetch("key_publish_article_right_column_#{column_id}/#{begin_num}/#{end_num}", 1.day) do
      options = {}
      column_names     = parameters.map { |p| p.gsub('-', '_') }
      options[:select] = column_names.dup
      options[:offset] = begin_num if begin_num > 0
      options[:limit]  = limit if limit
      ::Hejia::Promotion.items(column_id, options).map do |item|
        h = {}
        parameters.each_with_index do |param, index|
          column = column_names[index]
          # 为了兼容原有的用法
          h[param] = h[column] =
            if column == 'image_url'
              item[column].blank? && 'http://img.51hejia.com/api/images/none.gif' ||
                item[column] !~ HTTP_URL_PATTERN && (::Hejia::Promotion::ASSET_URL + item[column]) ||
                item[column]
            else
              item[column]
            end || ''
        end
        h
      end # inject
    #end # fetch
  else
    []
  end
end

#按tag生成代码
def generatecodebytagnew options={}
  articles = HejiaIndex.findnamebylike( 
                                       :etype =>options[:etype], 
                                       :beginnum => options[:beginnum], 
                                       :allnum => options[:allnum], 
                                       :title =>options[:title] ) 
  
  return generaterubynew(:articles => articles,
                         :namelength => options[:namelength],
                         :deslength => options[:deslength],
                         :buju => options[:buju],
                         :classid =>options[:classid])
  
end
#按id生成代码
def generatecodebyidnew options={}
  
  articles = HejiaIndex.findbyids(:ids => options[:ids])
  
  return generaterubynew(:articles => articles,
                         :namelength => options[:namelength],
                         :deslength => options[:deslength],
                         :buju => options[:buju],
                         :classid =>options[:classid])  
end
def generaterubynew options={}
  namelength = options[:namelength]
  deslength = options[:deslength]
  classid = options[:classid]
  buju = options[:buju]
  articles = options[:articles]
  
  str = ''
  buju = '21' if buju.nil?
  
  if buju == '21'
    str = str + '<ul>'
    articles.each do |article| 
      url = article.url
      str = str + "<li><a href='"+url+"' target='_blank' title='"+article.title+"'>"+article.title.chars[0,namelength.to_i]+"</a><span class=date>"+article.created_at.strftime('%m-%d')+"</span></li> \n "
    end
    str = str + '</ul>'
  elsif buju == '22'
    str = str + '<ul>'
    articles.each do |article| 
      url = article.url
      str = str + "<li><a href='"+url+"' target='_blank' title='"+article.title+"'>"+article.title.chars[0,namelength.to_i]+"</a></li> \n "
    end
    str = str + '</ul>'
  elsif buju == '23'
    articles.each do |article| 
      url = article.url
      imgurl = article.image_url
      str = str + "<img src='"+imgurl+"' alt='"+article.title+"'>"
      str = str + '<h4>'
      str = str + "<a href='"+url+"' target='_blank' title='"+article.title+"'>"+article.title.chars[0,namelength.to_i]+"</a></h4> \n "
      str = str + '<p>'+article.description.chars[0,deslength.to_i] +'...[<a href='+url+' target=_blank>详细</a>]</p>'
    end  
  elsif buju == '24'
    articles.each do |article| 
      url = article.url
      imgurl = article.image_url
      str = str + '<h4>'
      str = str + "<a href='"+url+"' target='_blank' title='"+article.title+"'>"+article.title.chars[0,namelength.to_i]+"</a></h4> \n "
      str = str + '<p>'+article.description.chars[0,deslength.to_i] +'...[<a href='+url+' target=_blank>详细</a>]</p>'
    end
  elsif buju == '25'
    str = str + ''
    articles.each do |article| 
      url = article.url
      imgurl = article.image_url
      str = str + '<dl><dt><a href='+url+' target=_blank title='+article.title+'><img src='+imgurl+' alt='+article.title+'  height=97 border=0 /></a></dt>' 
      str = str + '<dd><a href='+url+' target=_blank title='+article.title+'>' +article.title.chars[0,12]+'</a></dd></dl>' 
    end
  elsif buju == '26'
    articles.each do |article| 
      url = article.url
      imgurl = article.image_url
      str = str + '<a href='+url+' target=_blank title='+article.title+'><img src='+imgurl+' alt='+article.title+' border=0 width=150 height=95 /></a>' 
    end
  end
  
  return str
end

#获取基础信息中的重要度项目
def get_important_score_item
  return get_item_by_key('A5')
end

#获得基础信息中的编辑评分项目
def get_editor_score_item
  return get_item_by_key('A1')
end

#获得基础信息中真实性项目
def get_real_score_item
  return get_item_by_key('A4')
end

#获得评论点击基分项目
def get_click_score_item
  return get_item_by_key('A2')
end

#获得评论回复基分项目
def get_reply_score_item
  return get_item_by_key('A3')
end

#新近分项目
def get_new_commer_item
  return get_items_by_key('A6')
end

#登陆基分项
def get_log_item
  return get_item_by_key('A7')
end

#登陆最大分项
def get_log_max_item
  return get_item_by_key('A8')
end

#加速度
def get_addspeed
  return get_item_by_key('B2')
end

#公司星级标准
def get_star_score_items
  return get_items_by_key('B1')
end

def get_item_by_key(keyword)
  key = "zhaozhuangxiu_base_data_key_#{keyword}_#{Time.now.strftime('%Y%m%d%H')}"
  if CACHE.get(key).nil?
    result = JfBase.find(:first,:conditions => "keyword = '#{keyword}' and status = 1",:order => 'id desc')
    CACHE.set(key,result)
  else
    result = CACHE.get(key)
  end
  return result
end

def get_items_by_key(keyword)
  key = "zhaozhuangxiu_base_datas_key_2_#{keyword}_#{Time.now.strftime('%Y%m%d%H')}"
 # if CACHE.get(key).nil?
    result = JfBase.find(:all,:conditions => "keyword = '#{keyword}' and status = 1",:order => 'id asc')
  #  CACHE.set(key,result)
 # else
  #  result = CACHE.get(key)
 # end
  return result
end
