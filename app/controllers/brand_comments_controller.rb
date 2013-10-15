class BrandCommentsController < ProductsController
  COMMENT_FORM_ID = 83
  # GET /comments
  # GET /comments.xml
  def index
    if params[:brand_id]
      @comments = BrandComment.paginate :per_page => 15, :page => params[:page],
        :conditions => ["formid = #{COMMENT_FORM_ID} and c21 = ? and isdelete = ?", params[:brand_id], 0],
        :order => "cdate desc"
      @brand = ProductBrand.find(params[:brand_id])
      @want_to_use = BrandComment.brand_use_count(@brand.id, 1)
      @do_not_want_use = BrandComment.brand_use_count(@brand.id, 2)
      @useing = BrandComment.brand_use_count(@brand.id, 3)
      @good_ragting = BrandComment.brand_rating_count(@brand.id, 1)
      @bad_ragting = BrandComment.brand_rating_count(@brand.id, 2)
    else
      @comments = BrandComment.paginate :per_page => 15, :page => params[:page],
        :conditions => ["formid = #{COMMENT_FORM_ID} and isdelete = ?", 0],
        :order => "cdate desc"
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @comments }
    end
  end

  # GET /comments/1
  # GET /comments/1.xml
  def show
    @comment = Comment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @comment }
    end
  end

  # GET /comments/new
  # GET /comments/new.xml
  def new
    @comment = Comment.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @comment }
    end
  end

  # GET /comments/1/edit
  def edit
    @comment = Comment.find(params[:id])
  end

  # POST /comments
  # POST /comments.xml
  def create
    @comment = Comment.new(params[:comment])

    respond_to do |format|
      if @comment.save
        flash[:notice] = 'Comment was successfully created.'
        format.html { redirect_to(@comment) }
        format.xml  { render :xml => @comment, :status => :created, :location => @comment }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /comments/1
  # PUT /comments/1.xml
  def update
    @comment = Comment.find(params[:id])

    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        flash[:notice] = 'Comment was successfully updated.'
        format.html { redirect_to(@comment) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.xml
  def destroy
    @comment = BrandComment.find(params[:id])
    @comment.destroy

    render :update do |page|
      page.visual_effect :highlight, @comment.dom_id
      page.remove @comment.dom_id
    end
  end

  def is_good
    @comment = BrandComment.find(params[:id])
    checked_value = params[:cvalue]
    if checked_value == "true"
      @comment.update_attribute(:c23, 1)
      render_string = "<strong>精华</strong>"
    else
      @comment.update_attribute(:c23, 0)
      render_string = "普通"
    end
    render :update do |page|
      page.replace_html "is_good_#{@comment.dom_id}", render_string
			page.visual_effect(:highlight, "is_good_#{@comment.dom_id}")
		end
  end
  
  def is_verify
    @comment = BrandComment.find(params[:id])
    checked_value = params[:cvalue]
    if checked_value == "true"
      @comment.update_attribute(:c33, 1)
      render_string = "<strong>审核</strong>"
    else
      @comment.update_attribute(:c33, 0)
      render_string = "否"
    end
    render :update do |page|
      page.replace_html "is_verify_#{@comment.dom_id}", render_string
			page.visual_effect(:highlight, "is_verify_#{@comment.dom_id}")
		end
  end
end
