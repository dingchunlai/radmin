class Decos::PhotosController < DecosController

  def index
		@photos = @firm.photos.paginate :per_page => 20, :page => params[:page], :order => "created_at desc"
  end

  def show
		@photo = DecoPhoto.find(params[:id])
		unless @photo.entity == @firm
			flash[:notice] = "对不起，您没有该活动的管理权限！"
			redirect_to deco_photos_url
		end
  end

  def new
    @photo = DecoPhoto.new
  end

  def create
    @photo = @firm.photos.build(params[:photo])
    if !params[:photo].values.include?("") && @photo.image_file_size/1024 < 200 && @photo.save
      decofirm = DecoFirm.find(@photo.entity_id)
      new_count = decofirm.photos_count.to_i + 1
      decofirm.update_attribute("photos_count",new_count )
      flash[:success] = "施工图片创建成功！"
      redirect_to deco_photos_url
    else
      if @photo.title== ""
        flash[:notice] = "提示：请填写标题"
      elsif @photo.summary == ""
        flash[:notice] = "提示：请填写简介"
      elsif @photo.image_file_name.nil?
        flash[:notice] = "提示：请上传图片"
      elsif @photo.image_file_size/1024 >200
        flash[:notice] = "提示：对不起，您上传的图片大小以超过限制，应该将上传的图片控制在200KB以内"
      end
      render :action => "new"
    end
  end

  def edit
    @photo = DecoPhoto.find(params[:id])
  end

  def update
    @photo = DecoPhoto.find(params[:id])
    if @photo.update_attributes(params[:photo])
      flash[:success] = "活动更新成功！"
      redirect_to deco_photos_url
    else
      flash[:notice] = "活动更新失败！"
      render :action => "edit"
    end
  end

  #对施工图片的批量删除已放置于/decos/photos_destory(decos_controller.rb)
  def destroy
    if params[:id]
      @photo = DecoPhoto.find(params[:id])
      if @photo.destroy
        decofirm = DecoFirm.find(@photo.entity_id)
        new_count = decofirm.photos_count.to_i - 1
        decofirm.update_attribute("photos_count",new_count )
        redirect_to deco_photos_url
      end
    end
  end
end
