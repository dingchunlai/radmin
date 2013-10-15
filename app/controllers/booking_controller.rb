class BookingController < ApplicationController
  #搜索预约单
  def index
    @status = params[:status]
    
    conditions = []
    conditions << "1=1"
    conditions << "status = '#{@status}'" if @status && @status != ''
    
    @bookinglist = BookingDeco.paginate :page => params[:page], :per_page => 20,
    :conditions => conditions.join(" and "),
    :order => " id desc "
    
  end
  
  #查看详细
  def bookingdetail
    @bookingdeco = BookingDeco.find(params[:id])
  end
  
  #审核或者退回预约单
  def check
    checkstate = params[:checkstate]
    
    bookingdeco = BookingDeco.find(params[:id])
    bookingdeco.status = checkstate
    bookingdeco.save
    
    redirect_to :action => "index",
    :status => params[:status],
    :page => params[:page]
    
  end
end
