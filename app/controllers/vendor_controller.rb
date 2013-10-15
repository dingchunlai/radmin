class VendorController < ApplicationController
  #before_filter :vendor_validate #验证用户身份
  layout "vendor"
  
  before_filter :find_vendor, :except => [:login, :login_action]
  helper :products
  
  in_place_edit_for :product, :model
  in_place_edit_for :product, :unit
  in_place_edit_for :product, :now_price

  uses_tiny_mce :options => {
                              :language => 'zh',
                              :theme => 'advanced',
                              :width => "740px",
                              :convert_urls => false,
                              :relative_urls => false,
                              :visual => false,
                              :theme_advanced_buttons1 => "bold,italic,underline,strikethrough,|,justifyleft,justifycenter,justifyright,justifyfull,|,bullist,numlist,|,formatselect,fontselect,fontsizeselect,|,outdent,indent,blockquote,|,undo,redo",
                              :theme_advanced_buttons2 => "tablecontrols,|,hr,removeformat,visualaid,code |,hr,removeformat,visualaid,|,link,unlink,anchor,image,upload,cleanup,|,forecolor,backcolor,code",
                              :theme_advanced_buttons3 => "",
                              :theme_advanced_resizing => true,
                              :theme_advanced_resize_horizontal => false,
                              :theme_advanced_toolbar_location => "top",
                              :theme_advanced_toolbar_align => "left",
                              :theme_advanced_statusbar_location => "bottom",
                              :plugins => %w{ table fullscreen upload}
                            },
                  :only => [:new, :create, :edit, :update]

  def index
    #@products = @vendor.products.find(:all, :limit => 20, :order => "created_at desc")
  end

  def edit
    
  end

  def update
    @vendor.companyid = ProductVendor.maximum('companyid') + 1 unless @vendor.companyid
    if @vendor.update_attributes(params[:vendor])
      if params[:image]
        if @vendor.image
          @image = @vendor.image
          @image.update_attributes(params[:image])
        else
          @image = ProductVendorImage.new(params[:image])
          @image.vendor = @vendor
          @image.save
        end
      end
      flash[:success] = "商家信息更新成功！"
      redirect_to "/vendor/profile"
    else
      flash[:notice] = "商家信息更新失败！"
      render :action => "edit"
    end
  end

  def profile
    
  end

  def login
    if cookies["vendor_id"]
      flash[:notice] = "您已经成功登录！"
      redirect_to "/vendor"
    else
      render :layout => "simple"
    end
  end

  def login_action
    login = params[:login]
    password = params[:password]
    vendor = ProductVendor.find_by_login(login)
    unless vendor
      flash[:notice] = "用户名不存在！"
      render :action => "login", :layout => "simple"
    else
      if vendor.password == md5(password)
        cookies.delete :vendor_id, :domain=>".51hejia.com"
        cookies.delete :vendor_name, :domain=>".51hejia.com"
        cookies["vendor_id"] = {:value => vendor.id.to_s, :domain=>".51hejia.com"}
        cookies["vendor_name"] = {:value => vendor.login, :domain=>".51hejia.com"}
        @vendor = vendor
        flash[:success] = "登录成功！"
        redirect_to "/vendor"
      else
        flash[:notice] = "密码错误！"
        render :action => "login", :layout => "simple"
      end
    end
  end

  def logout
    cookies.delete :vendor_id, :domain=>".51hejia.com"
    redirect_to "/vendor/login"
  end

  def change_password
    if request.method == :post
      password = params[:password]
      if @vendor.password == md5(password)
        new_password = params[:new_password]
        repeat_password = params[:repeat_password]
        if new_password == repeat_password
          @vendor.update_attribute(:password, md5(new_password))
          flash[:success] = "密码修改成功！"
          redirect_to "/vendor"
        else
          flash[:notice] = "输入的新密码不一样，请重新输入！"
          render :action => "change_password"
        end
      else
        flash[:notice] = "旧密码不正确，请重新出入！"
        render :action => "change_password"
      end
    end
  end

  private
  def find_vendor
#    @vendor = ProductVendor.find(1809)
    unless cookies["vendor_id"].nil?
      @vendor = ProductVendor.find(cookies["vendor_id"].to_i)
      logger.info "log in status *****************************************************"
      logger.info cookies["vendor_id"]
    else
      flash[:notice] = "请登录！"
      logger.info "log out status *****************************************************"
      redirect_to "/vendor/login"
    end
  end

  
end
