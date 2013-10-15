class BaselogdateController < ApplicationController
  #基础数据
  def index
    @dlist = Basslogdata.find(:all,:conditions => "state=1")
  end
  
  #新增(类型：推广性文章，新闻，实用性文章)
  def add
    if request.post?
      b = Basslogdata.new
      b.dname = params[:dname]
      b.dtype = params[:dtype]
      b.dvalue = params[:dvalue]
      b.state = 1
      b.save
      
      redirect_to :action =>'index'
    end
  end 
  
  #修改(类型：推广性文章，新闻，实用性文章)
  #  def edit
  #    @d = Basslogdata.find(params[:id])
  #    if request.post?
  #      
  #    end
  #  end
  
 
  #删除基础数据
  def delete
    b = Basslogdata.find(params[:id])
    b.state=0
    b.save
    
    redirect_to :action => "index"
  end
end
