class Admin::PhotosController < DecocompanyController

  def index
    if params[:firm_id]
      @photos = DecoPhoto.paginate :page => params[:page], :per_page => 20, :conditions => ["entity_id = ?", params[:firm_id]],  :order => "created_at desc"
    elsif params[:firm_name] || params[:is_certificated]
      @firm_name = params[:firm_name]
      @is_certificated = params[:is_certificated]
      @conditions = []
#      if @firm_name && @is_certificated
#        @conditions << "exists (select 1 from deco_firms d where entity_id=d.id and entity_type='DecoFirm' and d.name_zh like '%#{@firm_name}%')"
#      end
#      @conditions << "exists (select 1 from deco_firms d where entity_id=d.id and entity_type='DecoFirm' and d.name_zh like '%#{@firm_name}%')"
      @photos = DecoPhoto.paginate :page => params[:page], :per_page => 20, :order => "created_at desc", :conditions => "exists (select 1 from deco_firms d where entity_id=d.id and entity_type='DecoFirm' and d.name_zh like '%#{@firm_name}%')"
    else
      @photos = DecoPhoto.paginate :page => params[:page], :per_page => 20, :order => "created_at desc"
    end
  end

  def show
    @photo = DecoPhoto.find(params[:id])
  end
  def edit
    @photo = DecoPhoto.find(params[:id])
  end

  def update
    @photo = DecoPhoto.find(params[:id])
    if @photo.update_attributes(params[:photo])
      flash[:success] = "活动更新成功！"
      redirect_to admin_photos_url
    else
      flash[:notice] = "活动更新失败！"
      render :action => "edit"
    end
  end

  def destroy
    @photo = DecoPhoto.find(params[:id])
    @photo.destroy
    redirect_to admin_photos_url
  end

  def operate
    #return false unless check_administrator_role
    if params[:certificated]
      DecoPhoto.update_all(["is_certificated = ?", true], "id in (#{params[:photo_ids].join(',')})")
      flash[:success] = "选中图片通过认证！"
    elsif params[:uncertificated]
      DecoPhoto.update_all(["is_certificated = ?", false], "id in (#{params[:photo_ids].join(',')})")
      flash[:success] = "选中图片取消通过认证！"
    end
    redirect_to request.referer
  end

  def search
    redirect_to admin_photos_url(:firm_name => params[:firm_name], :is_certificated => params[:is_certificated])
  end

end
