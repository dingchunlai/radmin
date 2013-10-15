require 'RMagick'
class UploadController < ApplicationController   
  
   #before_filter :configure_charsets
  
  #def configure_charsets
  #  @headers["Content-Type"]="text/html;charset=utf-8"
  #end
  
  def upload_mianliao_img_save  #保存面料图片
    unless request.get?  
      file = params[:file]['file']
      if file==""
            render :text => "<script>alert('请先选择文件!');history.back();</script>"  #没有接收到文件参数,自动返回
      else
            if !file.original_filename.empty?   
                #有接收到文件
                if file.size/1024>300
                    render :text => "<script>alert('您不能上传超过300K的图片!');history.back();</script>" 
                else
                    @filename=getFileName(file.original_filename)    
                    File.open("#{RAILS_ROOT}/public/upload/mianliao/#{@filename}", "wb") do |f|   
                      f.write(file.read)   
                    end   
                    mianliao_thumb_create(@filename) #制作面料缩略图
                    render :text => "<script>parent.form1.zhaopian.value='#{@filename}';history.back();</script>"
                end
            else
                #没有接收到文件
            end 
      end    
    end 
  end
  
  def mianliao_thumb_create(filename) #制作面料缩略图
      imgpath = "public/upload/mianliao/"
      pic = Magick::Image.read("#{imgpath}#{filename}").first
      l = pic.columns > pic.rows ? pic.columns : pic.rows
      f = 128.0/l;
      thumb = pic.thumbnail(f)
      thumb.write("#{imgpath}thumb/#{filename}")  #保存缩略图
  end
  
  def upload_chengpin_img_save  #保存成品图片
    unless request.get?  
      file = params[:file]['file']
      if file==""
            render :text => "<script>alert('请先选择文件!');history.back();</script>"  #没有接收到文件参数,自动返回
      else
            if !file.original_filename.empty?   
                #有接收到文件
                if file.size/1024>300
                    render :text => "<script>alert('您不能上传超过300K的图片!');history.back();</script>" 
                else
                    @filename=getFileName(file.original_filename)    
                    File.open("#{RAILS_ROOT}/public/upload/chengpin/#{@filename}", "wb") do |f|   
                      f.write(file.read)   
                    end   
                    chengpin_thumb_create(@filename) #制作面料缩略图
                    render :text => "<script>parent.form1.zhaopian.value='#{@filename}';history.back();</script>"
                end
            else
                #没有接收到文件
            end 
      end    
    end 
  end
  
  def chengpin_thumb_create(filename) #制作成品缩略图
      imgpath = "public/upload/chengpin/"
      pic = Magick::Image.read("#{imgpath}#{filename}").first
      l = pic.columns > pic.rows ? pic.columns : pic.rows
      f = 128.0/l;
      thumb = pic.thumbnail(f)
      thumb.write("#{imgpath}thumb/#{filename}")  #保存缩略图
  end
  
  def uploadFile(file)   
    if !file.original_filename.empty?   
      @filename=getFileName(file.original_filename)    
      File.open("#{RAILS_ROOT}/public/upload/#{@filename}", "wb") do |f|   
      f.write(file.read)   
      end   
      return @filename  
    end   
  end   
  
  def getFileName(filename)   
    if !filename.nil?   
      Time.now.strftime("%Y_%m_%d_%H_%M_%S") + '_' + filename   
    end   
  end   
  
  def save   
    unless request.get?   
      if filename=uploadFile(params[:file]['file'])   
        render :text=>filename   
      end   
    end   
  end    

end