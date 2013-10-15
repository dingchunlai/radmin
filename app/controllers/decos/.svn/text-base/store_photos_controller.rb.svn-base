class Decos::StorePhotosController < DecosController
  # TODO Generated stub
  before_filter :find_firm
  
  def index
    @store_photos = @firm.store_photos(:all, :order => :position)
  end
  
  def new
    @store_photo = StorePhoto.new
  end
  
  def create
    picture = params[:picture]
    @store_photo = StorePhoto.new(params[:store_photo])
    @store_photo.deco_firm_id = @firm.id
    if @store_photo.save
      @picture = Picture.new(picture)
      @picture.item = @store_photo
      @picture.save
    end 
    redirect_to :action => :index
  end
  
  def edit
    @store_photo = StorePhoto.find(params[:id])
  end
  
  def update
    store_photo = StorePhoto.find(params[:id])
    if store_photo.update_attributes(params[:store_photo])
      picture = Picture.find(params[:picture_id])
      picture.update_attributes(params[:picture])
    end 
    redirect_to :action => :index
  end
    
  def sort
    params[:store_photos].each_with_index do |id, position|
        StorePhoto.update(id, :position => position + 1 )
    end
    render :nothing => true
  end
  
  def destroy
    @store_photo = StorePhoto.find(params[:id])
    @store_photo.destroy
    redirect_to :action => :index
  end
  
end