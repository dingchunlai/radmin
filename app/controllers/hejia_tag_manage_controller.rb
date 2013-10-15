class HejiaTagManageController < ApplicationController
  helper :layout
  layout 'bad_words'
  
  def index
    if params[:city_name]
      @tag = HejiaTag.find(:first, :conditions => "TAGNAME='#{params[:city_name]}'")
      if @tag
        @tag_subdirecotries = HejiaTag.find(:all, :select => "TAGID, TAGNAME", :conditions => ["TAGFATHERID = ? and TAGTYPE='china'", @tag.TAGID])
        render :partial => "/hejia_tag_manage/seach_result"
      else
        render :text => "sorry";
      end
    end
  end

  def manage_subdirectories
    @tags = HejiaTag.paginate :page => params[:page], :per_page => 20,:conditions => "TAGFATHERID=#{params[:tagfatherid]}"
    render  "hejia_tag_manage/index"
  end

  def edit_subdirectories
    @tag = HejiaTag.find(params[:tagid])
  end
  
  def subdirectories_update
    if params[:type] == 'new'
      HejiaTag.create(:TAGFATHERID => params[:tagfatherid], :TAGNAME => params[:city_name], :TAGURL => params[:city_pinyin], :TAGTAXIS => 0, :TAGESTATE => 0, :TAGTYPE => 'china', :BIDDING => 1, :subdomain => 'www')
      render :text => "ok";
    elsif params[:type] == 'edit'
      @tag = HejiaTag.find(params[:tagid])
      @tag.update_attributes(:TAGNAME => params[:tagname], :TAGURL => params[:tagpinyin])
      render :action => 'index'
    end
  end

end
