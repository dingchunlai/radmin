class PagesController < ApplicationController
  #列表
  def index
    @fname = params[:fname]
    @show = params[:show]
    conditions = []
    conditions << "STATE='1'"
    conditions << "REMARK like '%#{@fname}%'" if @fname && @fname != ''
    if !@show.nil? && @show.to_s =='1'
      conditions << "`SHOW` = '#{@show}'"
    elsif !@show.nil? && @show.to_s =='0'
      conditions << "(`SHOW` = '#{@show}' or `SHOW` is null)"
    else
    end
    @ps = Page.paginate :page => params[:page], :per_page => 20,
    :conditions => conditions.join(" and "),
    :order => 'ID desc'
  end
  
  #增加
  def new
    unless request.get?
      p = Page.new
      p.PAGENOS = 1
      p.REMARK = params[:remark]
      p.PUBLISHTIME = Time.now
      p.STATE = '1'
      p.SHOW = '0'
      p.DOMAIN = params[:domain]
      if strip(params["file"][:myfile].to_s) != ""
        file = uploadFile(params[:file]['myfile'],'')     
        if file
          p.NAME = file
        end
      end
      p.save!
      redirect_to :action => "show", :id=>p.ID
    end
  end
  
  #修改入口
  def show
    @p = Page.find(params[:id].to_i)
  end
  
  #修改
  def edit
    p = Page.find(params[:id].to_i)
    p.REMARK = params[:remark]
    p.DOMAIN = params[:domain]
    if strip(params["file"][:myfile].to_s) != ""
      uploadFile(params[:file]['myfile'],p.NAME)
    end
    p.save!
    redirect_to :action => "show", :id=>params[:id]
  end
  
  #删除
  def delete
    p = Page.find(params[:id].to_i)
    p.STATE = '0'
    p.save!
    redirect_to :action => "index"
  end
  
  #刷新功能
  def refresh
    unless params[:id].to_i == 8702
      page = Page.find params[:id]

      #来源文件
      template = "#{RAILS_ROOT}/public/files/myfile/#{page.NAME}"

      #目标文件
      output_filename = page.HTMLFILE
      output_filename = "#{Time.now.to_i}.html" if output_filename.blank?
      output_file = "#{RAILS_ROOT}/public/files/outfile/#{output_filename}"

      #获得生成的html内容
      html = ERB.new(File.read(template)).result

      unless html.blank?
        # 写入目标文件
        File.open(output_file, 'w') { |f| f << html }

        # 给小罗自动刷新用
        File.open("#{RAILS_ROOT}/public/files/outfile/#{page.DOMAIN}.html", 'w') do |f|
          f << html
        end if page.DOMAIN && page.DOMAIN != '' && html.size > 300

        # 修改数据库
        page.HTMLFILE = output_filename
        page.SHOW = '1'
        page.save!
      else
        flash[:alert] = '页面刷新失败（不能读取内容）'
      end
    end
  rescue
    flash[:alert] = "页面刷新失败（异常：#{$!}）"
    flash[:errors] = "<ul><li>#{$@.join('</li><li>')}</li></ul>"
  ensure
    redirect_to :action => "index"
  end
  
  #预览
  def preview
    p = Page.find(params[:id].to_i)
    path = "#{RAILS_ROOT}/public/files/myfile/"+p.NAME
    str = ''
    File.open(path,"r") do |f|
      str = str + f.read
    end
    message = ERB.new(str)
    render :text => message.result
  end
  
  require 'hpricot' 
  #修改模版生成页面（整体）
  def showmoban
    pageid = params[:id]    
    
    document = gethtmldocument(pageid)
    
    doc = Hpricot.parse(document)  
    
    doc.search('div').each do |item|  
      if item.attributes['id'] && item.attributes['id'].include?('sub_')
        divid = item.attributes['id']
        item.inner_html = item.inner_html+"<a href='/pages/editmoban?pageid=#{pageid}&divid=#{divid}' >修改</a>&nbsp;<a href='/pages/choosemoban?pageid=#{pageid}&divid=#{divid}'>选择</a>&nbsp;<a href='/pages/backarea?pageid=#{pageid}&divid=#{divid}'>恢复</a>&nbsp;<a href='/pages/bbsmoban?pageid=#{pageid}&divid=#{divid}'>讨论区</a>"
      end
    end
    
    render :text => doc.to_html
  end
  
  def test
    p = Page.find(8075)
    path = "#{RAILS_ROOT}/public/files/outfile/temp"+p.HTMLFILE
    
    #读取源文件
    document = ''
    File.open(path,"r") do |f|
      document = document + f.read
    end
    doc = Hpricot.parse(document)  
    
    doc.search("meta[@name=keywords]").each do |t|
      t.set_attribute("content","aaa")#.attr("content") = "aaa"
    end
    #    doc.search("meta[@name=description]").attr("content") = "bbb"
    
    File.open(path,"w") do |f|
      f.write(doc.to_html)
    end
    #    doc.get_elements_by_tag_name('title').each do |t|
    #      render :text => t.inner_html 
    #    end
    
    #    element = doc.get_element_by_id('titleid')
    
    #    render :text => element.inner_html   
  end
  
  #修改标题描述等信息
  def editother
    @pageid = params[:pageid]
    p = Page.find(@pageid)
    path = "#{RAILS_ROOT}/public/files/outfile/temp"+p.HTMLFILE
    
    #读取源文件
    document = ''
    File.open(path,"r") do |f|
      document = document + f.read
    end
    doc = Hpricot.parse(document)  
    
    @title = doc.search("title").inner_html
    @description = doc.search("meta[@name=description]").attr("content")
    @keywords = doc.search("meta[@name=keywords]").attr("content") 
    @domain = p.DOMAIN
    
    #如果修改,title,description,keywords
    if request.post?
      doc.search("meta[@name=keywords]").each do |t|
        t.set_attribute("content",params[:keywords])
      end
      doc.search("meta[@name=description]").each do |t|
        t.set_attribute("content",params[:description])
      end      
      doc.get_elements_by_tag_name('title').each do |t|
        t.inner_html = params[:title]
      end     
      
      File.open(path,"w") do |f|
        f.write(doc.to_html)
      end      
      
      if params[:domain] && params[:domain] != ''
        p.DOMAIN = params[:domain]
        p.save
      end
      
      redirect_to :action => "showmoban",:id => @pageid
    end
    
  end
  
  #设置指定地区为评论区
  def bbsmoban
    pageid = params[:pageid]
    divid = params[:divid]
    
    p = Page.find(pageid)
    path = "#{RAILS_ROOT}/public/files/outfile/temp"+p.HTMLFILE
    
    #读取源文件
    document = ''
    File.open(path,"r") do |f|
      document = document + f.read
    end
    
    doc = Hpricot.parse(document)  
    
    doc.search("div[@id=#{divid}]").each do |item|
      if item.inner_html.include?('theme_id')
        item.inner_html = "<script language='javascript' src='http://radmin.51hejia.com/comment/show?theme_id="+pageid.to_s+"&sort_id=2' charset='utf-8'></script>"
      end
    end  
    
    File.open(path,"w") do |f|
      f.write(doc.to_html)
    end
    
    redirect_to :action => "showmoban",:id => pageid
  end
  
  #局部恢复到原始状态
  def backarea
    pageid = params[:pageid]
    divid = params[:divid]    
    
    p = Page.find(pageid)
    path = "#{RAILS_ROOT}/public/files/outfile/temp"+p.HTMLFILE
    
    mobanid = p.TYPELEVEL
    moban = Moban.find(mobanid)
    mobanpath = "#{RAILS_ROOT}/public/files/myfile/"+moban.path
    
    #读取模板该区域代码
    document = ''
    File.open(mobanpath,"r") do |f|
      document = document + f.read
    end
    
    tempcontent = ''
    sourcedoc = Hpricot.parse(document)  
    sourcedoc.search("div[@id=#{divid}]").each do |item|
      tempcontent = item.inner_html      
    end
    
    #目标文件该区域代码替换
    target = ''
    File.open(path,"r") do |f|
      target = target + f.read
    end    
    targetdoc = Hpricot.parse(target)  
    targetdoc.search("div[@id=#{divid}]").each do |item|
      item.inner_html = tempcontent
    end
    
    #替换完成生成临时页
    File.open(path,"w") do |f|
      f.write(targetdoc.to_html)
    end
    
    redirect_to :action => "showmoban",:id => pageid
  end
  
  #手动修改模版生成页面
  def editmoban
    @pageid = params[:pageid]
    @divid = params[:divid]
    
    p = Page.find(@pageid)
    path = "#{RAILS_ROOT}/public/files/outfile/temp"+p.HTMLFILE
    
    
    #读取源文件
    document = ''
    File.open(path,"r") do |f|
      document = document + f.read
    end
    
    doc = Hpricot.parse(document)  
    
    #非提交修改则显示原来内容
    if !request.post?
      #指定id内容匹配显示
      @content = ''
      doc.search("div[@id=#{@divid}]").each do |item|
        @content = item.inner_html      
      end
    end
    
    
    #提交修改，回到整体修改页
    if request.post?
      newcontent = params[:newcontent]
      
      doc.search("div[@id=#{@divid}]").each do |item|
        item.inner_html = newcontent
      end
      
      #写临时文件
      File.open(path,"w") do |f|
        f.write(doc.to_html)
      end
      
      redirect_to :action => "showmoban",:id => @pageid
    end
    
  end
  
  #选择修改模版生成页面
  def choosemoban
    pageid = params[:pageid]
    divid = params[:divid]
    
    session[:moban_divid] = divid
    session[:moban_pageid] = pageid
    
    redirect_to :controller => "article",:action => "index"
  end
  
  #从文章中选择后进入
  def genmoban
    divid = session[:moban_divid]
    pageid = session[:moban_pageid]
    if divid && divid != '' && pageid && pageid != ''
      #生成代码
      choosecontent = params[:choosecontent]
      puts "============"
      
      puts choosecontent
      
      puts "=========="
      content = ERB.new(choosecontent)
      
      p = Page.find(pageid)
      path = "#{RAILS_ROOT}/public/files/outfile/temp"+p.HTMLFILE
      
      #读取临时文件
      document = ''
      File.open(path,"r") do |f|
        document = document + f.read
      end
      
      #替代文件指定div内容
      doc = Hpricot.parse(document)  
      doc.search("div[@id=#{divid}]").each do |item|
        item.inner_html = content.result
      end
      
      #写临时文件
      File.open(path,"w") do |f|
        f.write(doc.to_html)
      end
      
      session[:moban_divid] = nil
      session[:moban_pageid] = nil
      
      redirect_to :action => "showmoban",:id => pageid
    else
      render :text => "操作错误,请重新选择文章"
    end
  end
  
  #模版生成文件刷新
  def refreshmoban
    #从临时文件复制到正式文件
    pageid = params[:pageid]
    
    p = Page.find(pageid)
    path = "#{RAILS_ROOT}/public/files/outfile/temp"+p.HTMLFILE
    outpath = "#{RAILS_ROOT}/public/files/outfile/"+p.HTMLFILE
    
    #读取临时文件
    document = ''
    File.open(path,"r") do |f|
      document = document + f.read
    end
    
    #写正式文件
    File.open(outpath,"w") do |f|
      f.write(document)
    end      
    show = '1'
    p.SHOW = show
    p.save!
    redirect_to :action => "index"
  end
  
  #根据模版生成页面id获得临时内容
  def gethtmldocument(pageid)
    p = Page.find(pageid)
    path = "#{RAILS_ROOT}/public/files/outfile/temp"+p.HTMLFILE
    #读取源文件
    document = ''
    File.open(path,"r") do |f|
      document = document + f.read
    end
    
    return document
  end
  
  def zhuanti_picture_upload
    file = params[:pages][:uploaded_data]
    title = params[:pages][:title]
    
    filename = uploadImage(file,'')
    
    save_path = "/images/binary/"
    @insertString = "<img src=\"#{save_path}#{filename}\" alt=\"#{title}\" />"
    session[:backitem] = save_path + filename
    s = session[:backitem]
    logger.info("==================")
    logger.info(s)
    logger.info("==================")
    render :layout => false
  end
  
  #上传文件相关 
  def getFileName(file)  
    Time.now.strftime("%Y%m%d").to_s+Time.now.to_i.to_s+file.original_filename
  end 
  
  def uploadFile(file,fname) 
    if fname && fname != ''    
      @filename=fname
    else
      @filename=getFileName(file)
    end   
    
    File.delete("#{RAILS_ROOT}/public/files/myfile/#{@filename}") if File.exist?("#{RAILS_ROOT}/public/files/myfile/#{@filename}")
    File.open("#{RAILS_ROOT}/public/files/myfile/#{@filename}", "wb") do |f|   
      f.write(file.read)  
    end   
    
    return @filename  
    
  end 
  
  def getImageName(file)  
    Time.now.strftime("%Y%m%d").to_s+Time.now.to_i.to_s+file.original_filename
  end 
  
  def uploadImage(file,fname) 
    if fname && fname != ''    
      filename=fname
    else
      filename=getFileName(file)
    end   
    
    File.delete("#{RAILS_ROOT}/public/images/binary/#{filename}") if File.exist?("#{RAILS_ROOT}/public/images/binary/#{filename}")
    File.open("#{RAILS_ROOT}/public/images/binary/#{filename}", "wb") do |f|   
      f.write(file.read)  
    end   
    
    return filename  
    
  end 
  #
  #从文章中选择后进入
  def genmobannew
    divid = session[:moban_divid]
    pageid = session[:moban_pageid]
    if divid && divid != '' && pageid && pageid != ''
      #生成代码
      choosecontent = params[:choosecontent]
      puts choosecontent
      content = ERB.new(choosecontent)
      
      p = Page.find(pageid)
      path = "#{RAILS_ROOT}/public/files/outfile/temp"+p.HTMLFILE
      
      #读取临时文件
      document = ''
      File.open(path,"r") do |f|
        document = document + f.read
      end
      
      #替代文件指定div内容
      doc = Hpricot.parse(document)  
      doc.search("div[@id=#{divid}]").each do |item|
        item.inner_html = content.result
      end
      
      #写临时文件
      File.open(path,"w") do |f|
        f.write(doc.to_html)
      end
      #新
      refreshpath = "#{RAILS_ROOT}/public/files/outfile/refresh"+p.HTMLFILE
      
      #读取新临时文件
      documentfresh = ''
      File.open(refreshpath,"r") do |f|
        documentfresh = documentfresh + f.read
      end
      
      #替代新文件指定div内容
      docrefresh = Hpricot.parse(documentfresh)  
      docrefresh.search("div[@id=#{divid}]").each do |item|
        puts "==============1"
        puts choosecontent.to_s
        puts "==============2"
        item.inner_html = choosecontent.to_s
      end
      
      #写新临时文件
      File.open(refreshpath,"w") do |f|
        f.write(docrefresh.to_html)
      end
      
      session[:moban_divid] = nil
      session[:moban_pageid] = nil
      
      redirect_to :action => "showmobanedit",:id => pageid
    else
      render :text => "操作错误,请重新选择文章"
    end
  end
  #根据模版生成页面id获得临时内容
  def gethtmldocumentfresh(pageid)
    p = Page.find(pageid)
    path = "#{RAILS_ROOT}/public/files/outfile/refresh"+p.HTMLFILE
    #读取源文件
    document = ''
    File.open(path,"r") do |f|
      document = document + f.read
    end
    
    return document
  end
  
  #修改模版生成页面（整体）
  def showmobannew
    pageid = params[:pageid]
    document = gethtmldocumentfresh(pageid)
    
    doc = Hpricot.parse(document)  
    doc.search('div').each do |item|  
      if item.attributes['id'] && item.attributes['id'].include?('sub_')
        divid = item.attributes['id']
        content = ERB.new(item.inner_html)
        item.inner_html = content.result
      end
    end
    render :text => doc.to_html
  end
  
  #修改模版生成页面（整体）
  def showmobanedit
    pageid = params[:id]    
    
    document = gethtmldocument(pageid)
    
    doc = Hpricot.parse(document)  
    
    doc.search('div').each do |item|  
      if item.attributes['id'] && item.attributes['id'].include?('sub_')
        divid = item.attributes['id']
        item.inner_html = item.inner_html+"<a href='/pages/editmobannew?pageid=#{pageid}&divid=#{divid}' >修改</a>&nbsp;<a href='/pages/choosemoban?pageid=#{pageid}&divid=#{divid}'>选择</a>&nbsp;<a href='/pages/backarea?pageid=#{pageid}&divid=#{divid}'>恢复</a>&nbsp;<a href='/pages/bbsmoban?pageid=#{pageid}&divid=#{divid}'>讨论区</a>"
      end
    end
    
    render :text => doc.to_html
  end
  
  #模版生成文件刷新
  def refreshmobannew
    #从临时文件复制到正式文件
    pageid = params[:pageid]
    document = gethtmldocumentfresh(pageid)
    
    doc = Hpricot.parse(document)  
    doc.search('div').each do |item|  
      if item.attributes['id'] && item.attributes['id'].include?('sub_')
        divid = item.attributes['id']
        content = ERB.new(item.inner_html)
        item.inner_html = content.result
      end
    end
    p = Page.find(pageid)
    path = "#{RAILS_ROOT}/public/files/outfile/temp"+p.HTMLFILE
    outpath = "#{RAILS_ROOT}/public/files/outfile/"+p.HTMLFILE
    
    #写正临时文件
    File.open(path,"w") do |f|
      f.write(doc.to_html)
    end 
    
    #写正式文件
    File.open(outpath,"w") do |f|
      f.write(doc.to_html)
    end      
    show = '1'
    p.SHOW = show
    p.save!
    redirect_to :action => "index"
  end
  
  #修改标题描述等信息new
  def editothernew
    @pageid = params[:pageid]
    p = Page.find(@pageid)
    path = "#{RAILS_ROOT}/public/files/outfile/temp"+p.HTMLFILE
    refreshpath = "#{RAILS_ROOT}/public/files/outfile/refresh"+p.HTMLFILE
    #读取源文件
    document = ''
    File.open(path,"r") do |f|
      document = document + f.read
    end
    doc = Hpricot.parse(document)  
    documentrefresh = ''
    File.open(refreshpath,"r") do |f|
      documentrefresh = documentrefresh + f.read
    end
    docrefresh = Hpricot.parse(documentrefresh)  
    
    @title = doc.search("title").inner_html
    @description = doc.search("meta[@name=description]").attr("content")
    @keywords = doc.search("meta[@name=keywords]").attr("content") 
    @domain = p.DOMAIN
    
    #如果修改,title,description,keywords
    if request.post?
      doc.search("meta[@name=keywords]").each do |t|
        t.set_attribute("content",params[:keywords])
      end
      doc.search("meta[@name=description]").each do |t|
        t.set_attribute("content",params[:description])
      end      
      doc.get_elements_by_tag_name('title').each do |t|
        t.inner_html = params[:title]
      end     
      
      docrefresh.search("meta[@name=keywords]").each do |t|
        t.set_attribute("content",params[:keywords])
      end
      docrefresh.search("meta[@name=description]").each do |t|
        t.set_attribute("content",params[:description])
      end      
      docrefresh.get_elements_by_tag_name('title').each do |t|
        t.inner_html = params[:title]
      end
      
      File.open(path,"w") do |f|
        f.write(doc.to_html)
      end      
      File.open(refreshpath,"w") do |f|
        f.write(docrefresh.to_html)
      end
      if params[:domain] && params[:domain] != ''
        p.DOMAIN = params[:domain]
        p.save
      end
      
      redirect_to :action => "showmobannew",:id => @pageid
    end
    
  end
  #手动修改模版生成页面
  def editmobannew
    @pageid = params[:pageid]
    @divid = params[:divid]
    
    p = Page.find(@pageid)
    path = "#{RAILS_ROOT}/public/files/outfile/temp"+p.HTMLFILE
    refreshpath = "#{RAILS_ROOT}/public/files/outfile/refresh"+p.HTMLFILE
    
    #读取源文件
    document = ''
    File.open(path,"r") do |f|
      document = document + f.read
    end
    doc = Hpricot.parse(document)
    
    documentfresh = ''
    File.open(refreshpath,"r") do |f|
      documentfresh = documentfresh + f.read
    end
    docfresh = Hpricot.parse(documentfresh)  
      
    
    #非提交修改则显示原来内容
    if !request.post?
      #指定id内容匹配显示
      @content = ''
      doc.search("div[@id=#{@divid}]").each do |item|
        @content = item.inner_html      
      end
      
#      #指定id内容匹配显示
#      @contentfresh = ''
#      docfresh.search("div[@id=#{@divid}]").each do |item|
#        @contentfresh = item.inner_html      
#      end
    end
    
    
    #提交修改，回到整体修改页
    if request.post?
      newcontent = params[:newcontent]
      
      doc.search("div[@id=#{@divid}]").each do |item|
        item.inner_html = newcontent
      end
      
      #写临时文件
      File.open(path,"w") do |f|
        f.write(doc.to_html)
      end
      
      docfresh.search("div[@id=#{@divid}]").each do |item|
        item.inner_html = newcontent
      end
      
      #写临时文件
      File.open(refreshpath,"w") do |f|
        f.write(docfresh.to_html)
      end
      
      redirect_to :action => "showmobanedit",:id => @pageid
    end
    
  end

  def static_files
    # 因为radmin没有对爬虫进行限制，导致百度收录了这里面的页面，而不是实际地址上的页面，
    # 现在把这些页面重定向到正确的地址上
    if params[:id] == '1248166694' # 居尚
      headers["Status"] = "301 Moved Permanently"
      redirect_to 'http://www.51hejia.com/jushang/'
    else
      file = File.join(RAILS_ROOT, request.request_uri)
      if params[:id]['..'].nil? && File.file?(file)
        render :file => file
      else
        render :file => File.join(RAILS_ROOT, 'public/404.html'), :status => 404
      end
    end
  end
end
