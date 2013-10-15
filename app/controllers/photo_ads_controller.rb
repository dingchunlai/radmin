class PhotoAdsController < ApplicationController
before_filter :user_validate  #验证用户身份
  helper :photo_ads

  def index
    @ad_codes = AdCode.paginate :per_page => 15, :page => params[:page]
  end

  def new
    @ad_code = AdCode.new
    @ad_code.tag_father_id = Tag.photo_first_tag.first.TAGID
    collention = Tag.photo_first_tag.first.valid_children
    @select_options = create_select_options(collention.first.TAGID, collention, {:text => :TAGNAME, :value => :TAGID, :include_blank => false})
  end

  def show
    @ad_code = AdCode.find(params[:id])
  end

  def create
    @ad_code = AdCode.new(params[:ad_code])
    @ad_code.tag_id = params[:tag_id]
    @ad_code.tag_url = Tag.find(params[:tag_id]).TAGURL unless params[:tag_id].blank?
    if @ad_code.save
      flash[:success] = "广告代码添加成功！"
      redirect_to photo_ad_url(@ad_code)
    else
      flash[:error] = "广告代码添加失败！"
      redirect_to new_photo_ad_url
    end
  end

  def edit
    @ad_code = AdCode.find(params[:id])
    collention = Tag.find(@ad_code.tag_id).parent.valid_children
    @select_options = create_select_options(@ad_code.tag_id, collention, {:text => :TAGNAME, :value => :TAGID, :include_blank => false})
  end

  def update
    @ad_code = AdCode.find(params[:id])
    if @ad_code.update_attributes(params[:ad_code]) && @ad_code.update_attribute(:tag_id, params[:tag_id])
      @ad_code.update_attribute(:tag_url, Tag.find(params[:tag_id]).TAGURL) unless params[:tag_id].blank?
      flash[:success] = "广告代码更新成功！"
      redirect_to photo_ad_url(@ad_code)
    else
      flash[:error] = "广告代码更新失败！"
      redirect_to edit_photo_ad_url(@ad_code)
    end
  end

  def destroy
    @ad_code = AdCode.find(params[:id])
    @ad_code.destroy

    render :update do |page|
      page.visual_effect :highlight, @ad_code.dom_id
      page.remove @ad_code.dom_id
    end
  end

  def children_tag_update
    return unless request.xhr?
    @tag = Tag.find(params[:tag_father_id])
    second_class = @tag.valid_children
    render :update do |page|
      page << update_select_box( "tag_id", second_class, {:text => :TAGNAME, :value => :TAGID, :include_blank => false} )
      page.visual_effect(:highlight, "tag_id", :duration => 0.5)
    end
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
