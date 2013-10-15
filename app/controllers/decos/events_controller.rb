class Decos::EventsController < DecosController

  def index
		@events = @firm.all_events.find(:all, :order => "LIST_INDEX desc").paginate :per_page => 20, :page => params[:page]
  end

  def show
		@event = DecoEvent.find(params[:id])
		unless @event.firms.include?(@firm)
			flash[:notice] = "对不起，您没有该活动的管理权限！"
			redirect_to deco_events_url
		end
  end

  def new
    @event = DecoEvent.new
  end

  def create
    @event = DecoEvent.new(params[:event])
    @event.firms << @firm
    if @event.save
      flash[:success] = "活动创建成功！"
      redirect_to deco_event_url(@event)
    else
      flash[:notice] = "活动创建失败！"
      render :action => "new"
    end
  end

  def edit
    @event = DecoEvent.find(params[:id])
  end

  def update
    @event = DecoEvent.find(params[:id])
    if @event.update_attributes(params[:event])
      flash[:success] = "活动更新成功！"
      redirect_to deco_event_url(@event)
    else
      flash[:notice] = "活动更新失败！"
      render :action => "edit"
    end
  end

  def destroy
    @event = DecoEvent.find(params[:id])
    @event.destroy
    redirect_to deco_events_url
  end

  def sort
    order_number = 1
    params[:events].each do |id|
      DecoEvent.update_all("LIST_INDEX = #{order_number}",:ID=>id)
      order_number += 1
    end
    render :nothing => true
  end

end
