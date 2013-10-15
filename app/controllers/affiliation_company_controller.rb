# -*- coding: utf-8 -*-
class AffiliationCompanyController < ApplicationController

  def new
    p "======================="
    p flash if flash
    p "====================＝＝"
    if params[:create_status]
      company = session[:affliation_company]
      company.default = ""
      @company = DecoInfo.new(company)
    end
    @style = OddHejiaTag.find(:all, :select => "tagid,tagname", :conditions => "tagfatherid = 4348").map { |u| [u.tagname, u.tagid] }
    @vantage = [["设计",0], ["施工",1], ["报价",2],["服务",3],["其他",4]]
    @values = OddHejiaTag.find :all, :select => "tagid,tagname", :conditions => "tagfatherid = 4349"
    @cities = OddHejiaTag.find(:all, :select => 'tagid, tagname', :conditions => 'tagfatherid = 15000').map {|u| [u.tagname, u.tagid]}
    @regions = OddHejiaTag.find(:all, :select => 'tagid, tagname', :conditions => 'tagfatherid = 11910').map {|u| [u.tagname, u.tagid]}


  end


  def create
    if request.post?

      flash[:errors] = ""
      flash[:errors] << "必须接受条款<br />" unless params[:accept] == "1"
      if params[:PASSWORD] == params[:CONFIRM_PASSWORD]
        params[:user].merge({:USERSPASSWORD => Digest::MD5.hexdigest(params[:PASSWORD])})
      else
        flash[:errors] << "密码不同 <br />"
      end
      user =  HejiaUserBbs.new(params[:user])
      begin
        DecoInfo.transaction do
          if user.save
            params[:company].merge(:USER_ID => user.id)
            deco = DecoInfo.new(params[:company])
            if deco.save
              user.update_attribute_with_validation_skipping('deco_id' , deco.id)
              selected_ids.each do |id|
                HejiaTagLink.create(:ENTITYID => deco.id, :TAGID => id, :LINKTYPE => 'deco_company')
              end
            else
              Hash[*deco.errors.sum].values.each do |error|
                flash[:errors] << "#{error} <br />"
              end
            end
          else
            Hash[*user.errors.sum].values.each do |error|
              flash[:errors] << "#{error} <br />"
            end
          end
        end
      rescue
        p "save decorate error"
      end
      unless flash[:errors].blank?
        session[:affliation_company] = params[:company]
        redirect_to :action => :new, :create_status => 'error_return'
      else
        session[:affliation_company] = nil
        redirect_to :action => :success
      end
    else
      redirect_to :action => :new
    end
  end

  def success
    render :text => 'success'
  end

  def select_city

    city = params[:city]
    @regions = OddHejiaTag.find(:all, :select => 'tagid, tagname', :conditions => ['tagfatherid = ?', city]).map {|u| [u.tagname, u.tagid]}
    render :partial => 'select_city'
  end
end
