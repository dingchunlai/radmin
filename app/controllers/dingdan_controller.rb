class DingdanController < ApplicationController
  before_filter :need_inneruser, :user_validate, :except => :login #验证用户身份

  def vendor_cstatus
    return false unless pvalidate("修改商铺状态","管理员","商家管理")
    Vendor.update_all("status = #{params[:status]}", "id in (#{params[:ids]})") unless params[:ids].nil?
    render :text => js(top_load("self"))
  end

  def vendor_savelogininfo
    return false unless pvalidate("修改商铺登录信息","管理员","商家管理")
    begin
      Vendor.update_all("login='#{trim(params[:login])}', password='#{md5(trim(params[:pw]))}'", "id = #{params[:id]}")
      render :text => alert("操作成功：用户名及密码保存成功！")
    rescue Exception => e
      render :text => alert_error("操作失败：#{get_error(e)}")
    end
  end

  def vendor_list
    return false unless pvalidate("商家管理","管理员","商家管理")
    @pagesize = 15 #每页记录数
    @listsize = 10 #同时显示的页码数
    @id = params[:id]
    @name_zh = params[:name_zh]
    @telephone = params[:telephone]
    @login = params[:slogin]
    @status = params[:status]

    if pp(@status)
      cd = "status = #{@status}"
    else
      cd = "status <> 3"
    end
    cd += " and id = #{@id}" if pp(@id)
    cd += " and name_zh like '%#{@name_zh}%'" if pp(@name_zh)
    cd += " and telephone like '%#{@telephone}%'" if pp(@telephone)
    cd += " and login like '%#{@login}%'" if pp(@login)

    if params[:page].nil?
    @curpage = 1
    else
    @curpage = params[:page].to_i
    end
    if params[:recordcount].nil?
    @recordcount = Vendor.count("id", :conditions => cd)
    else
    @recordcount = params[:recordcount].to_i
    end
    @pagecount = (1.0 * @recordcount / @pagesize).ceil
    @vendors = Vendor.find :all,
#      :select => "id,name,telephone,created_at,booking_at,status",
      :conditions => cd,
      :offset => @pagesize * (@curpage - 1),
      :limit => @pagesize,
      :order => "updated_at desc"
  end

  def list
    return false unless pvalidate("订购单管理","管理员","订单管理")
    @pagesize = 15 #每页记录数
    @listsize = 10 #同时显示的页码数
    @name = params[:name]
    @telephone = params[:telephone]
    @user_id = params[:user_id]
    @status = params[:status]
    @riqi1 = params[:riqi1]
    @riqi2 = params[:riqi2]

    @cd = "true"
    @cd += " and name like '%#{@name}%'" if pp(@name)
    @cd += " and telephone like '%#{@telephone}%'" if pp(@telephone)
    @cd += " and user_id = #{@user_id}" if pp(@user_id)
    @cd += " and booking_at >= '#{@riqi1}'" if pp(@riqi1)
    @cd += " and booking_at <= '#{@riqi2}'" if pp(@riqi2)
    @cd += " and status = #{@status}" if pp(@status)

    if params[:page].nil?
    @curpage = 1
    else
    @curpage = params[:page].to_i
    end
    if params[:recordcount].nil?
    @recordcount = Order.count("id", :conditions => @cd)
    else
    @recordcount = params[:recordcount].to_i
    end
    @pagecount = (1.0 * @recordcount / @pagesize).ceil
    @orders = Order.find :all,
      :select => "id,name,telephone,created_at,booking_at,status",
      :conditions => @cd,
      :offset => @pagesize * (@curpage - 1),
      :limit => @pagesize,
      :order => "id desc"
  end

  def detail
   return false unless pvalidate("订购单详情","管理员","订单管理")
   @order = Order.find(params[:id],:select => "id,user_id,name,telephone,created_at,booking_at,status,remark")
   ois = OrderItem.find(:all, :select=>"id, product_id, price, amount", :conditions=>["order_id = ?",@order.id])
   product_ids = ";"
   @price = Hash.new
   @amount = Hash.new
   for oi in ois
     product_ids += ("," + oi.product_id.to_s)
     @price[oi.product_id] = oi.price
     @amount[oi.product_id] = oi.amount
   end
   product_ids = product_ids.gsub(";,","")
   @products = Product.find(:all, :select=>"id,productid,model,name,brand_id", :conditions=>"id in (#{product_ids})") if product_ids != ";"
  end

  def remark_save
  return false unless pvalidate("保存订购单备注","管理员","订单管理")
  begin
    order = Order.find(params[:id1],:select => "id,remark")
    order.remark = params[:remark]
    order.save
    render :text => alert("操作成功：备注信息已保存!")# + js(top_load("self"))
  rescue Exception => e
    render :text => alert_error("操作失败：#{get_error(e)}")
  end
  end

  def chengjiao #成交订购单操作
   return false unless pvalidate("成交订购单操作","管理员","订单管理")
   Order.update_all("status = 3", "id in (#{params[:ids]})") unless params[:ids].nil?
   render :text => js(top_load("self"))
  end

  def zuofei #作废订购单操作
   return false unless pvalidate("作废订购单操作","管理员","订单管理")
   Order.update_all("status = 4", "id in (#{params[:ids]})") unless params[:ids].nil?
   render :text => js(top_load("self"))
  end
end
