class CommentsController < ProductsController

  def index
    if params[:vendor_id]
      @vendor = ProductVendor.find(params[:vendor_id])
      @comments = @vendor.comments.paginate :page => params[:page], :per_page => 20, :include => [:product], :conditions => ["parent_id is ?", nil], :order => "product_comments.created_at desc"
    elsif params[:product_id]
      @product = Product.find(params[:product_id])
      @comments = @product.comments.paginate :page => params[:page], :per_page => 20, :include => [:vendor], :conditions => ["parent_id is ?", nil], :order => "product_comments.created_at desc"
    else
      @comments = ProductComment.paginate :page => params[:page], :per_page => 20, :include => [:product, :vendor], :conditions => ["parent_id is ?", nil], :order => "product_comments.created_at desc"
    end
  end

  def new
    if params[:product_id]
      @product = Product.find(params[:product_id])
      @comment = ProductComment.new
      @comment.city_id = 376 #上海
      @comment.product_id = @product.id
      @comment.brand_id = @product.brand.id if @product.brand
      @comment.vendor_id = @product.vendor.id if @product.vendor
      @comment.province_id = @comment.city.parent.id
      collention = @comment.city.parent.children
      @select_options = create_select_options(@comment.city_id, collention, {:text => :name_zh, :include_blank => true})
    end
  end

  def create
    @comment = ProductComment.new(params[:comment])
    @comment.city_id = params[:city_id]
    if @comment.save
      @parent_comment = @comment.parent
      if @parent_comment
        @parent_comment.update_attribute(:state, "replied")
        @parent_comment.save
        render :update do |page|
          page.insert_html :bottom, "comments_#{@parent_comment.dom_id}", :partial => "comment", :locals => {:comment => @comment}
          #page.select('#comment_form').reset()
        end
      else
        @comment.product.log_event("product_comment", current_staff.id)
        flash[:success] = "评论创建成功！"
        redirect_to :action => "index"
      end
    else
      flash[:error] = "评论创建失败！"
      redirect_to :action => "new", :product_id => @comment.product_id
    end
  end

  def edit
    @comment = ProductComment.find(params[:id])
    @product = @comment.product
    @comment.province_id = @comment.city.parent.id
    collention = @comment.city.parent.children
    @select_options = create_select_options(@comment.city_id, collention, {:text => :name_zh, :include_blank => true})
  end

  def destroy
    @comment = ProductComment.find(params[:id])
    @comment.destroy
    render :update do |page|
      page.visual_effect :highlight, @comment.dom_id
      page.remove @comment.dom_id
    end
  end

  def operate
    if params[:destroy_all] && params[:comment_ids]
      ProductComment.destroy_all(:id => params[:comment_ids])
      flash[:notice] = "选中评论已经删除！"
    end
    redirect_to request.referer
  end

  private

  # create options for select_tag
  # choice - which option selected
  # Options
  # :text - The method to use on collection objects to get the text for the option
  # :value - The method to use on collection objects to get the value attribute for the option
  # :include_blank - Includes a blank option at the top of cascaded boxes
  def create_select_options(choice, collection, options={})
    options[:text] ||= 'name'
    options[:value] ||= 'id'
    options[:include_blank] = true if options[:include_blank].nil?
    options[:clear] ||= []
    pre = options[:include_blank] ? "<option value="">""</option>" : ""
    collection.each { |c| pre << "<option value=#{c.send(options[:value])} #{"selected=\"selected\"" if choice == c.send(options[:value])}>#{c.send(options[:text])}</option>" }
    pre
  end
end
