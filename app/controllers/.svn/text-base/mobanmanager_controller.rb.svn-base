class MobanmanagerController < ApplicationController
  
  
  #模版列表
  def index
    name = params[:mobanname]
    
    if name && name != ''
      conditions = " name like '%#{name}%' and status = 1 "
    else
      conditions = ' status=1 '
    end
    
    @mobanlist = Moban.paginate :page => params[:page], :per_page => 20,:conditions => conditions,:order => 'id desc'
  end
  
  #新增
  def new
    if request.post?
      m = Moban.new
      m.name = params[:mobanname]
      if strip(params["file"][:myfile].to_s) != ""
        file = uploadFile(params[:file]['myfile'],'')     
        if file
          m.path = file
        end
      end
      m.status = '1'
      m.created_at = Time.now
      m.updated_at = Time.now
      m.save
      redirect_to :action => "index"
    end
    
  end
  
  #修改模板
  def update
    m = Moban.find(params[:id])
    if request.post?
      m.name = params[:mobanname]
      if strip(params["file"][:myfile].to_s) != ""
        file = uploadFile(params[:file][''])
      end
      m.update_at = Time.now
      m.save
    end
  end
  
  #删除
  def delete
    moban = Moban.find(params[:id])
    moban.status = '-1'
    moban.updated_at = Time.now
    moban.save
    redirect_to :action => "index"
  end
  
  #添加专题
  def addzhuanti
    @mobanid = params[:mobanid]
    if request.post?
      mobanname = params[:mobanname]
      mobancss = params[:mobancss]
      
      moban = Moban.find(@mobanid)
      
      #先从模版文件复制一份到临时文件和目标文件
      source = "#{RAILS_ROOT}/public/files/myfile/"+moban.path
      
      filename = generateuploadfilename
      tempoutpath = "#{RAILS_ROOT}/public/files/outfile/temp"+filename
      outpath = "#{RAILS_ROOT}/public/files/outfile/"+filename
      
      #读取源文件
      str = ''
      File.open(source,"r") do |f|
        str = str + f.read
      end
      
      #写临时文件
      File.open(tempoutpath,"w") do |f|
        f.write(str)
      end
      
      #写目标文件
      File.open(outpath,"w") do |f|
        f.write(str)
      end    
      
      p = Page.new
      p.PAGENOS = 2                 #2：生成类型
      p.REMARK = params[:mobanname] #名字
      p.PUBLISHTIME = Time.now      #发布时间
      p.STATE = '1'                 #状态
      p.PHOTO = mobancss            #样式
      p.TYPELEVEL = @mobanid        #模版id
      p.TYPE = current_staff.id if staff_logged_in?
      p.HTMLFILE = filename         #目标文件名
      p.save
      
      redirect_to :controller=>"pages",:action => "index"
    end
  end
  
  def generateuploadfilename
    return Time.now.to_i.to_s+".html"
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
  
  #添加专题多加一个专题页面
  def addzhuantinew
    @mobanid = params[:mobanid]
    if request.post?
      mobanname = params[:mobanname]
      mobancss = params[:mobancss]
      
      moban = Moban.find(@mobanid)
      
      #先从模版文件复制一份到临时文件和目标文件
      source = "#{RAILS_ROOT}/public/files/myfile/"+moban.path
      
      filename = generateuploadfilename
      tempoutpath = "#{RAILS_ROOT}/public/files/outfile/temp"+filename
      outpath = "#{RAILS_ROOT}/public/files/outfile/"+filename
      refreshoutpath = "#{RAILS_ROOT}/public/files/outfile/refresh"+filename
      #读取源文件
      str = ''
      File.open(source,"r") do |f|
        str = str + f.read
      end
      
      #写临时文件
      File.open(tempoutpath,"w") do |f|
        f.write(str)
      end
      
      #写目标文件
      File.open(outpath,"w") do |f|
        f.write(str)
      end    
      
      #写专区目标文件
      File.open(refreshoutpath,"w") do |f|
        f.write(str)
      end   
      
      p = Page.new
      p.PAGENOS = 3                 #2：生成类型 3:是专区
      p.REMARK = params[:mobanname] #名字
      p.PUBLISHTIME = Time.now      #发布时间
      p.STATE = '1'                 #状态
      p.PHOTO = mobancss            #样式
      p.TYPELEVEL = @mobanid        #模版id
      p.TYPE = current_staff.id if staff_logged_in?
      p.HTMLFILE = filename         #目标文件名
      p.save
      
      redirect_to :controller=>"pages",:action => "index"
    end
  end
  
end
