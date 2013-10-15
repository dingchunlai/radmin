class EventsController < ProductsController
  def index
    @events = Event.paginate :per_page => 10, :page => params[:page]
  end

  def show
    @event = Event.find(params[:id])
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(params[:event])
    if @event.save
      flash[:success] = '事件创建成功！'
      redirect_to :action => 'show', :id => @event
    else
      render :action => 'new'
    end
  end

  def edit
    @event = Event.find(params[:id])
  end

  def update
    @event = Event.find(params[:id])
    if @event.update_attributes(params[:event])
      flash[:notice] = '事件更新成功！'
      redirect_to :action => 'show', :id => @event
    else
      render :action => 'edit', :id => @event
    end
  end

  def destroy
    Event.find(params[:id]).destroy
    redirect_to :action => 'index'
  end
end
