class ArticletagController < ApplicationController
  def index
  end
  
  #大分类
  def index1
    @firstlist = ArticleTag.find(:all ,:conditions =>["TAGFATHERID = ? and TAGESTATE = 0",14025])
    render :layout => false  
  end
  
  #二级分类
  def index2
    @fatherid = params[:fatherid]
    if params[:fatherid] && params[:fatherid] != '0'
      @father1 = ArticleTag.find(params[:fatherid])
      @secondlist = @father1.sonlist
    end
    render :layout => false  
  end
  
  #三级分类
  def index3
    @fatherid = params[:fatherid]
    if params[:fatherid] && params[:fatherid] != '0'
      @father2 = ArticleTag.find(params[:fatherid])
      @thirdlist = @father2.sonlist
    end  
    render :layout => false  
  end
  
  #增加
  def create
    @type = params[:type] 
    @fatherid = params[:fatherid]
    
    if request.post?
      #保存tag
      t = ArticleTag.new
      t.TAGFATHERID = 14025  if @type=='1'
      t.TAGFATHERID = 7129   if @type=='2'
      t.TAGFATHERID = 7128   if @type=='3'
      t.TAGNAME = params[:tagname]
      t.TAGVALUE = params[:tagvalue]
      t.TAGURL = params[:tagurl]
      t.TAGTAXIS = 0
      t.TAGESTATE = '0'
      t.TAGDATE = Time.new
      t.TAGTYPE = 'newsClass'
      t.BIDDING = 0
      t.save
      
      #保存关联(2,3级分类需要)
      if @type != '1'
        tl = Taglink.new
        tl.TAGID1 = params[:fatherid]
        tl.TAGID2 = t.TAGID
        tl.save
        t.serializable_code
      end
      redirect_to :action => "show",:id => t.TAGID
    end
  end
  
  #显示
  def show
    @tag = ArticleTag.find(params[:id])
  end
  
  #修改
  def edit
    t = ArticleTag.find(params[:id])
    t.TAGNAME = params[:tagname]
    t.TAGVALUE = params[:tagvalue]
    t.TAGURL = params[:tagurl]
    t.save
    redirect_to :action => "show",:id => t.TAGID
  end
  
  #删除
  def delete
    t = ArticleTag.find(params[:id])
    t.TAGESTATE = '-1'
    t.save
    render :layout => false  
  end
end
