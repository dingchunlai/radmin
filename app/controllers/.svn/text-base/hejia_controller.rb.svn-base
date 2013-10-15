class HejiaController < ApplicationController

  before_filter :user_validate, :except => :login #验证用户身份
  require "active_support"
  include ActiveSupport
  
  def export_search
    export_excel(params[:cd])
  end

  def export_select
    export_excel("id in (#{params[:ids]})")
  end

  def export_excel(condition)
    return false unless pvalidate("导出核价单","管理员","核价组长","核价组员")
    array = Array.new
    pricings = Pricing.find :all,
        :select => "id, name, brand, xinghao, num, price, priceetime, pricestime, smalltype, username, userid, proid, passtime, oldprice, priceunit, phone, email, hopeaddress, state, createtime, chulistate, checknum, executor, address",
        :conditions => condition,
        :order => "id desc"
    for p in pricings
      item = OrderedHash.new
      item["编号"] = p.id
      item["客户姓名"] = p.username
      item["客户电话"] = p.phone
      item["日期"] = p.createtime.strftime("%Y-%m-%d %H:%M")
      item["产品名称"] = p.name
      item["品牌"] = p.brand
      item["型号"] = p.xinghao
      item["希望购买地"] = p.hopeaddress
      item["数量"] = p.num
      item["状态"] = HEJIA_STATE[p.chulistate]
      item["处理人员"] = p.user.rname rescue ""
      item["招商1"] = p.pricing_bill.zhaoshang rescue ""
      item["价格1"] = p.pricing_bill.sendprice rescue ""
      item["招商2"] = p.pricing_bill.zhaoshang2 rescue ""
      item["价格2"] = p.pricing_bill.sendprice2 rescue ""
      item["短信"] = p.pricing_bill.result rescue ""
      item["备注"] = p.pricing_bill.beizhu rescue ""
      array << item
    end
    e = Excel::Workbook.new
    e.addWorksheetFromArrayOfHashes("核价单列表", array)
    headers['Content-Type'] = "application/vnd.ms-excel"
    headers['Content-Disposition'] = 'attachment; filename="hejiadan.xls"'
    headers['Cache-Control'] = ''
    render :text=>e.build
  end

  #表单数据导出到Excel
  def export_form_data_to_excel
    return false unless pvalidate("导出表单数据","管理员","表单管理")
    array = Array.new
    limit = params[:export_rows] && params[:export_rows].to_i || 9999
    cols = params[:export_cols] && params[:export_cols].to_i || 8
    @columns = Column.find :all, :select => "id, sn, cname, ctype, ovalue, dvalue, remark", :conditions => "formid = #{params[:form_id]}"
    condition = "formid = #{params[:form_id]} and isdelete = 0"
    condition += " and status = #{params[:status]}" unless params[:status].blank?
    condition += " and cdate >= '#{params[:riqi1]}'" unless params[:riqi1].blank?
    condition += " and cdate <= '#{params[:riqi2]}'" unless params[:riqi2].blank?
    condition += " and c8 = '#{params[:city]}'" unless params[:city].blank?
    datas = Fdata.find(:all, :conditions => condition, :limit => limit)
    datas.each do |d|
      item = OrderedHash.new
      for col in @columns
        if col.ctype==5 and pp(eval("d.c#{col.sn}"))
          item["#{col.cname}"] = "/uploads/form_images/#{eval("d.c#{col.sn}")}"
        else
          item["#{col.cname}"] = eval("d.c#{col.sn}")
        end
      end

      item["状态"] = FORM_DATA_STATE[d.status]
      item["创建时间"] = d.cdate.nil? ? "" : d.cdate.strftime("%Y-%m-%d %H:%M")

      array << item
    end
    e = Excel::Workbook.new
    e.addWorksheetFromArrayOfHashes("表单数据汇总", array)
    headers['Content-Type'] = "application/vnd.ms-excel"
    headers['Content-Disposition'] = "attachment; filename=\"form_data_#{params[:form_id]}.xls\""
    headers['Cache-Control'] = ''
    render :text=>e.build
  end

  def edit
    return false unless pvalidate("编辑核价单","管理员","核价组长","核价组员")
    @pricing = Pricing.find(params[:id])
  end

  def edit_save
    return false unless pvalidate("保存核价单","管理员","核价组长","核价组员")
    begin
      id = params[:id1]
      pricing = Pricing.find(id)
      pricing.area = params[:area]
      pricing.name = params[:name1]
      pricing.brand = params[:brand]
      pricing.xinghao = params[:xinghao]
      pricing.hopeaddress = params[:hopeaddress]
      pricing.num = params[:num]
      pricing.save

      pb = PricingBill.find :first, :conditions => "pricing_id = #{id}"
      if pb.nil?
        pb = PricingBill.new
        pb.pricing_id = id
      end
      pb.zhaoshang = params[:zhaoshang]
      pb.sendprice = params[:sendprice]
      pb.zhaoshang2 = params[:zhaoshang2]
      pb.sendprice2 = params[:sendprice2]
      pb.result = params[:result]
      pb.beizhu = params[:beizhu]
      pb.save
      render :text => alert("操作成功：核价单已经保存！")
    rescue Exception => e
      render :text => alert_error("操作失败：#{get_error(e)}")
    end
  end

  def list
      return false unless pvalidate("核价单管理","管理员","核价组长","核价组员")
      @pagesize = 7 #每页记录数
      @listsize = 10 #同时显示的页码数
      @area = params[:area]
      @username = params[:username]
      @phone = params[:phone]
      @xinghao = params[:xinghao]
      @state = params[:state]
      @name = params[:name]
      @brand = params[:brand]
      @riqi1 = params[:riqi1]
      @riqi2 = params[:riqi2]
      if current_staff.admin? || current_staff.roles.include?("核价组长")
          @executor =  params[:executor]
          @is_zuzhang = true
      else
          @executor = current_staff.id
          @is_zuzhang = false
      end
      
      @cd = "true"
      if pp(@state)
        @cd += " and chulistate = #{@state}"
      else
        #@cd += " and chulistate not in (3, 5)"
      end
      @cd += " and area = '#{@area}'" if pp(@area)
      @cd += " and username like '%#{@username}%'" if pp(@username)
      @cd += " and phone like '%#{@phone}%'" if pp(@phone)
      @cd += " and xinghao like '%#{@xinghao}%'" if pp(@xinghao)
      @cd += " and name like '%#{@name}%'" if pp(@name)
      @cd += " and brand like '%#{@brand}%'" if pp(@brand)
      @cd += " and createtime >= '#{@riqi1} 0:0:0'" if pp(@riqi1)
      @cd += " and createtime <= '#{@riqi2} 23:59:59'" if pp(@riqi2)
      @cd += " and executor = #{@executor}" if pp(@executor)
      if params[:page].nil?
      @curpage = 1
      else
      @curpage = params[:page].to_i
      end
      if params[:recordcount].nil?
      @recordcount = Pricing.count("id", :conditions => @cd)
      else
      @recordcount = params[:recordcount].to_i
      end
      @pagecount = (1.0 * @recordcount / @pagesize).ceil
      @pricings = Pricing.find :all,
        :select => "id, name, area, brand, xinghao, num, price, priceetime, pricestime, smalltype, username, userid, proid, passtime, oldprice, priceunit, phone, email, hopeaddress, state, createtime, chulistate, checknum, executor, address",
        :conditions => @cd,
        :offset => @pagesize * (@curpage - 1),
        :limit => @pagesize,
        :order => "id desc"
   end

   def fenpei #分配核价单操作
     return false unless pvalidate("分配核价单操作","管理员","核价组长","核价组员")
     Pricing.update_all("executor = '#{params[:userID]}', chulistate = 6", "id in (#{params[:ids]})") unless params[:ids].nil?
     render :text => js(top_load("self"))
   end

   def chuli #处理核价单操作
     return false unless pvalidate("处理核价单操作","管理员","核价组长","核价组员")
     Pricing.update_all("chulistate = 1", "id in (#{params[:ids]}) and executor is not null") unless params[:ids].nil?
     render :text => js(top_load("self"))
   end

   def fasong   #改为已发送短信状态操作
     return false unless pvalidate("改为已发送短信状态操作","管理员","核价组长","核价组员")
     Pricing.update_all("chulistate = 2", "id in (#{params[:ids]}) and chulistate = 1") unless params[:ids].nil?
     render :text => js(top_load("self"))
   end

   def zuofei #作废核价单操作
     return false unless pvalidate("作废核价单操作","管理员","核价组长","核价组员")
     Pricing.update_all("chulistate = 3", "id in (#{params[:ids]})") unless params[:ids].nil?
     render :text => js(top_load("self"))
   end

   def chengjiao #成交核价单操作
     return false unless pvalidate("成交核价单操作","管理员","核价组长","核价组员")
     Pricing.update_all("chulistate = 4", "id in (#{params[:ids]}) and chulistate = 2") unless params[:ids].nil?
     render :text => js(top_load("self"))
   end

   def fangqi #放弃核价单操作
     return false unless pvalidate("放弃核价单操作","管理员","核价组长","核价组员")
     Pricing.update_all("chulistate = 5", "id in (#{params[:ids]}) and chulistate = 2") unless params[:ids].nil?
     render :text => js(top_load("self"))
   end

end
