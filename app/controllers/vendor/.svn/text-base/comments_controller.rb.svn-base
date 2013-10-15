class Vendor::CommentsController < VendorController
  def index
    @comments = @vendor.comments.paginate :page => params[:page], :per_page => "25", :conditions => ["parent_id is ?", nil], :order => "created_at desc"
    render :layout => "/layouts/vendor", :template => "/vendor/comments/index"
  end

  def create
    @comment = ProductComment.new(params[:comment])
    if @comment.save
      @parent_comment = @comment.parent
      @parent_comment.update_attribute(:state, "replied")
      @parent_comment.save
      render :update do |page|
        page.insert_html :bottom, "comments_#{@parent_comment.dom_id}", :partial => "comment", :locals => {:comment => @comment}
        #page.select('#comment_form').reset()
      end
    end
  end

  def destroy
    @comment = ProductComment.find(params[:id])
    @comment.destroy
    render :update do |page|
      page.visual_effect :highlight, @comment.dom_id
      page.remove @comment.dom_id
    end
  end
end
