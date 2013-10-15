# Methods added to this helper will be available to all templates in the application.
require 'open-uri'
require 'rexml/document'
include UserModule
include PublicModule

module ApplicationHelper
  
  include ActiveSupport
  
  
  
  def include_jquery
    content_for(:head) { 
      '<script type="text/javascript" src=" http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js"></script>
         <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.4/jquery-ui.min.js"></script>
      '}
    @include_jquery = true 
  end
  
  def array_to_hash(a, is_invert)
    h = OrderedHash.new
    0.upto(a.size) do |k|
      if is_invert
        h[a[k]] = k if pp(a[k])
      else
        h[k] = a[k] if pp(a[k])
      end
    end
    return h
  end
  
  def jquery_resource(options = nil)
    version = options[:version]
    if plugin = options[:plugin]
      resource = case options[:resource]
      when NilClass, :js, 'js'
        "jquery.#{plugin}.min.js?#{TIME_IN_SECONDS}"
      when :css, 'css'
        "jquery.#{plugin}.css?#{TIME_IN_SECONDS}"
      else
        options[:resource]
      end
      "http://js.51hejia.com/js/jquery/plugins/#{plugin}/#{version}/#{resource}"
    else
      "http://js.51hejia.com/js/jquery/#{version}/jquery.min.js?#{TIME_IN_SECONDS}"
    end
  end

  def get_array_title_and_url(str)  #通过换行符切割文本后取得包含“title与url哈希组”的数组
    new = []
    old = str.to_s.split("\r")
    if old.length > 1
      0.step(old.length-1, 2) do |i|
        new << {"title" =>old[i],"url" =>old[i+1]}
      end
    end
    return new
  end

  def gmb(value,url,onclick,style) #get_my_button
    onclick += "self.location.href='#{url}';" if pp(url)
    style += "letter-spacing:2px;" unless style.include?("letter-spacing:")
    style += "width:#{value.split(//u).length*18}px;" unless style.include?("width:")
    return "<input onclick=\"#{onclick}\" style=\"#{style}\" type=\"button\" value=\"#{value}\" class=\"btn1_mouseout\" onmouseover=\"this.className='btn1_mouseover'\" onmouseout=\"this.className='btn1_mouseout'\" />"
  end

  def utf8_left(str,length,replacer)
    a_str = str.split(//u)
    a_size = a_str.length
    if a_size > length
      str = a_str[0..(length-1)].join("") + replacer
    else
      return str
    end
  end

  def get_formselect(name, first, attrib, dv)
    dv = dv.to_i
    str = "<select name='#{name}' id='#{name}' #{attrib}>"
    str += "<option value=''>#{first}</option>" unless strip(first)==""
    h = get_webpm(name)
    for k in h.keys
      if dv == k.to_i
        str += "<option value='#{k}' selected>#{h[k]}</option>"
      else
        str += "<option value='#{k}'>#{h[k]}</option>"
      end
    end
    return str += "</select>"
  end

  def html_select_by_array(name, array, default_value, first_option, attribs)
    str = "<select name='#{name}' id='#{name}' #{attribs}>"
    str += "<option value=''>#{first_option}</option>" if trim(first_option).length > 0
    0.upto(array.length) do |i|
      next if trim(array[i]).length == 0
      if default_value.to_i == i
        str += "<option value='#{i}' selected>#{array[i]}</option>"
      else
        str += "<option value='#{i}'>#{array[i]}</option>"
      end
    end
    return str += "</select>"
  end

  def get_filepath_by_suffix(filepath, suffix)
    if suffix.nil?
      return filepath
    else
      extname = File.extname(filepath)
      return filepath.gsub(extname, "").gsub("/op/", "/tn/") + "_#{suffix}" + extname
    end
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

  def get_city_qq(deco_firm)
    city_id=get_city_id(deco_firm)
    city_name=CITIES[city_id]
    return  CITY_QQ[city_name]
  end

  def get_city_id(deco_firm)
    unless deco_firm.nil?
      city_id=11910
      temp_city_id=deco_firm.city.to_i 
      return city_id  if temp_city_id == 11910
      return city_id = deco_firm.district.to_i if temp_city_id!=0 && temp_city_id!= 11910
    end
  end

  # 在线活动
	def get_question_category(id)
		case id
    when 1 ; "生活知识"
    when 2; "巴迪斯产品知识"
    else "未分类"
		end
	end
	
	def has_1_currect_options(question)
		question.options.find(:all,:conditions=>"is_currect = true").size !=1
	end

	#对于新的图片系统,获取图片的完整路径
	def image_full_path(picture,size="",i=0)
    return "http://www.51hejia.com/api/images/none.gif" unless picture
	  if picture.image_url
	    picture.image_url
	  else
	    image_prefix = IMAGE_PREFIX_ARRAY[i % IMAGE_PREFIX_ARRAY.size]
	    if size.blank?
	      image_prefix + picture.image_id + "-" + picture.image_md5 + "." + picture.image_ext
      else
        image_prefix + picture.image_id + "-" + picture.image_md5 + "_"+ size + "." + picture.image_ext
      end
    end
	end
	
	def stylesheet(*args)
    content_for(:head) { stylesheet_link_tag(*args.map(&:to_s)) }
  end
  
  def radmin_stylesheet(*args)
    if RAILS_ENV == "development"
      content_for(:head) { stylesheet_link_tag(*args.map(&:to_s)) }
    else
      # TODO
      #  *args.map{|s| s = s + ".css" if s[-4..-1] != ".css" }
      content_for(:head) { stylesheet_link_tag(*args.map{|s| "http://js.51hejia.com/css/radmin/" + s.to_s  + "?" + TIMESTAMP }) }
    end
  end
  
  def radmin_javascript(*args)
    if RAILS_ENV == "development" || RAILS_ENV == "staging"
      content_for(:head) { javascript_include_tag(*args) }
    elsif RAILS_ENV=="rehearsal"
      content_for(:head) { javascript_include_tag(*args.map{|s| "http://js.51hejia.com/js/radmin/rehearsal/" + s.to_s + "?" + TIMESTAMP }) }
    else
      content_for(:head) { javascript_include_tag(*args.map{|s| "http://js.51hejia.com/js/radmin/" + s.to_s + "?" + TIMESTAMP }) }
    end
  end

  def javascript(*args)
    args = args.map { |arg| arg == :defaults ? arg : arg.to_s }
    content_for(:head) { javascript_include_tag(*args) }
  end

  #生成日记终端地址
  def gen_firm_city_diary_detail(diary)
    return gen_firm_city_path(diary.decoration_diary.deco_firm_id)+"zhuangxiugushi/#{diary.decoration_diary.id}" if diary.class == DecorationDiaryPost && diary.decoration_diary
    return gen_firm_city_path(diary.deco_firm_id)+"zhuangxiugushi/#{diary.id}" if diary.class == DecorationDiary
  end
  #生成设计理念终端页
  def gen_firm_city_deco_idea_detail(deco_idea)
    return gen_firm_city_path(deco_idea.deco_firm_id)+"shejilinian/#{deco_idea.id}"
  end

  #生成案例终端页
  def gen_firm_city_hejia_case_detail(anli)
    return gen_firm_city_path(anli.COMPANYID)+"cases-#{anli.ID}"
  end

  def get_domain(city_id)
    if city_id.to_i == 11910
      'http://z.shanghai.51hejia.com'
    elsif city_id.to_i == 12117
      'http://z.suzhou.51hejia.com'
    elsif city_id.to_i == 12122
      'http://z.nanjing.51hejia.com'
    elsif city_id.to_i == 12301
      'http://z.ningbo.51hejia.com'
    elsif city_id.to_i == 12306
      'http://z.hangzhou.51hejia.com'
    elsif city_id.to_i == 12118
      'http://z.wuxi.51hejia.com'
    else
      'http://z.51hejia.com'
    end
  end

  #生成公司地址
  def gen_firm_city_path(firm_id)
    firm = DecoFirm.find_by_id firm_id
    unless firm.blank?
      if firm.city.to_i == 11910
        result = get_domain(11910)
      else
        result = get_domain(firm.district)
      end
      result + "/gs-#{firm.id}/"
    else
      "#"
    end
  end

  def ul(str, len, preview=0, replacer="...")
    if preview == 1
      str = ""
      99.times { str += "预览内容" }
    end
    str = strip_tags(str.to_s)
    if str.length > 0
      s = str.split(//u)
      if s.length > len.to_i && len.to_i != 0
        return s[0, len.to_i].to_s + replacer
      else
        return str
      end
    else
      return ""
    end
  end

  def supply_by_new_diaries(limit, truncate = 16, l_wrap = '', r_wrap = '')
    str = []
    HejiaIndex.new_diaries(limit).each do |diary|
      str << "#{l_wrap}#{link_to(ul(diary.title,truncate,0,''), diary.url, :target => '_blank')}#{r_wrap}"
    end
    str.join()
  end

  #辅助will_paginate插件显示记录数的方法
  def mypage_entries_info(rs, options={})
    options[:show_total_entries] = true if options[:show_total_entries].nil?
    options[:show_page_link] = false if options[:show_page_link].nil?
    options[:entry_name] = "记录" if options[:entry_name].nil?
    total_page = (rs.total_entries.to_f/rs.per_page.to_f).ceil
    strs = []
    strs << "总共<b>#{rs.total_entries}</b>条#{options[:entry_name]}" if options[:show_total_entries]
    strs << "当前显示第<b>#{rs.current_page}</b>页 共<b>#{total_page}</b>页"
    strs << will_paginate(rs,:inner_window => 1,:outer_window => 1,:page_links => false,:prev_label => '上一页',:next_label => '下一页') if options[:show_page_link]
    return strs.join(" 　")
  end

  def show_firm_name_zh(firm_id)
    firm_id.to_i > 0 ? DecoFirm::show_firm_name_zh(firm_id) : "未命名"
  end

  def diary_remarks_size(diary)
    sum = 0
    diary.decoration_diary_posts.each do |body|
      sum += body.remarks.size
    end
    return sum
  end

  #原先放在remark_helper.rb中，由于商家后台也需要用
  def show_page(remark)
    if remark.parent_id
      remark = remark.parent
    elsif remark.resource.nil?
      return "该留言没有在前台显示"
    end
    case remark.resource_type
    when "DecorationDiary"
      link_to '日记' , gen_firm_city_diary_detail(remark.resource), :target => "_blank"
    when "DecorationDiaryPost"
      link_to '日记' , gen_firm_city_diary_detail(remark.resource), :target => "_blank"
    when "DecoFirm"
      link_to '公司' , gen_firm_city_path(remark.resource), :target => "_blank"
    when "DecoEvent"
      '优惠券'
    when "Case"
      link_to '案例' , gen_firm_city_hejia_case_detail(remark.resource), :target => "_blank"
    when "HejiaCase"
      link_to '图库' , "http://tuku.51hejia.com/zhuangxiu/tuku-#{remark.resource.id}", :target => "_blank"
    when "DecoIdea"
      link_to '设计理念' , gen_firm_city_deco_idea_detail(remark.resource), :target => "_blank"
    when "Coupon"
      link_to '现金券' , "http://#{COUPON_CITIE_PINYIN[remark.resource.city_id]}.youhui.51hejia.com/coupon/#{remark.resource.id}", :target => "_blank"
    end
  end

  def whitelist_strip_tags(html, options = {})
    return html if html.blank?
    if html.index('<')
      text = ""
      whitelist = options[:tags] || []
      tokenizer = HTML::Tokenizer.new(html)
      while token = tokenizer.next
        node = HTML::Node.parse(nil, 0, 0, token, false)
        text << node.to_s if HTML::Text === node || (options[:include] ? whitelist.include?(node.name) : !whitelist.include?(node.name))
      end
      text.gsub(/<!--(.*?)-->[\n]?/m, '')
    else
      html
    end
  end

  # 移除页面上外部链接
  def remove_external_links text
    text.gsub!(%r'(https?://|www\.)[[:graph:]]+') { |a| a =~ %r'http://([^/])*\.51hejia\.com' ? a : '' }
    text
  end

  def show_remark_city(remark)
    if remark.resource.nil?
      return "未知"
    elsif remark.parent_id
      remark = remark.parent
    end
    case remark.resource_type
    when "DecorationDiary"
      return remark.resource.deco_firm.city == 11910 ? "上海" : CITIES[remark.resource.deco_firm.district.to_i]
    when "DecorationDiaryPost"
      if remark.resource.decoration_diary
        return remark.resource.decoration_diary.deco_firm.city == 11910 ? "上海" : CITIES[remark.resource.decoration_diary.deco_firm.district.to_i]
      else
        return "未知"
      end
    when "DecoFirm"
      return remark.resource.city == 11910 ? "上海" : CITIES[remark.resource.district.to_i]
    when "DecoEvent"
      firm = DecoEvent.find_by_sql("select firm_id from deco_events_firms where event_id=#{remark.resource.id} limit 1")
      return DecoFirm.find(firm[0].firm_id.to_i).city == 11910 ? "上海" : CITIES[DecoFirm.find(firm[0].firm_id.to_i).district.to_i]
    when "Case"
      return remark.resource.deco_firm.city == 11910 ? "上海" : CITIES[remark.resource.deco_firm.district.to_i]
    when "HejiaCase"
      return remark.resource.deco_firm.nil? ? "上海" : (remark.resource.deco_firm.city == 11910 ? "上海" : CITIES[remark.resource.deco_firm.district.to_i])
    when "DecoIdea"
      return remark.resource.deco_firm.city == 11910 ? "上海" : CITIES[remark.resource.deco_firm.district.to_i]
    when "Coupon"
      return COUPON_CITIE_HANZI[remark.resource.city_id]
    end
  end

  # 显示错误信息提示
  def show_flash_message
  <<_HTML_
    <div style="color: red;font-size: 15px;">#{ flash[:notice] unless flash[:notice].blank? }</div>
_HTML_
  end


  #取CITIES里的城市,加上城市首字母,查询时排列

  def cities_for_query
    CITIES.inject([]) { |ary, item| key, city_name = item; ary << [key, "#{city_name.to_pinyin[0].chr.upcase}#{city_name}"] }.sort_by { |item| item[1][0].chr }
  end

end
