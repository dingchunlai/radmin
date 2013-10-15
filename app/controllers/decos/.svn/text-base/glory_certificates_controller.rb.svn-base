class Decos::GloryCertificatesController < DecosController
  # TODO Generated stub
  before_filter :find_firm

  def index
    @glory_certificates = @firm.glory_certificates(:all, :order => :position)
  end

  def new
    @glory_certificate = GloryCertificate.new
  end

  def create
    picture = params[:picture]
    @glory_certificate = GloryCertificate.new(params[:glory_certificate])
    @glory_certificate.deco_firm_id = @firm.id
    if @glory_certificate.save
      @picture = Picture.new(picture)
      @picture.item = @glory_certificate
      @picture.save
    end
    redirect_to :action => :index
  end

  def edit
    @glory_certificate = GloryCertificate.find(params[:id])
  end

  def update
    glory_certificate = GloryCertificate.find(params[:id])
    if glory_certificate.update_attributes(params[:glory_certificate])
      picture = Picture.find(params[:picture_id])
      picture.update_attributes(params[:picture])
    end
    redirect_to :action => :index
  end

  def sort
    params[:glory_certificates].each_with_index do |id, position|
      GloryCertificate.update(id, :position => position + 1 )
    end
    render :nothing => true
  end

  def destroy
    @glory_certificate = GloryCertificate.find(params[:id])
    @glory_certificate.destroy
    redirect_to :action => :index
  end

end