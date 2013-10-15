class CaseexcelController < ApplicationController
  require "active_support"
  include ActiveSupport
  def excel
    
    caselist = Excelcase.find(:all,:conditions=>"ID in (488208,486613,486612,486606,486562,486398,486557,488289,488284,488279,486608,488276,488266,488258,488256,488241,488238,488235,488234,488232,488231,488229,488227,488226,488214,488210,488207,488204,488203,488202,488200,488199,488194,488193,488946,488933,488909,488907,488904,488899,488898,487960,488894,488891,489119,489064,489059,489057,489054,489051,489050,489048,489046,489045,489041,489040,488972,488970,488966,488965,488964,488963,488957,488954,488949,488559,488548,488512,488511,488435,488433,489243,489233,489230,489228,489226,489225,489189,489187,489185)")
    
    array = Array.new
    for p in caselist
      item = OrderedHash.new
      yanse = ''
      huxing = ''
      yongtu = ''
      fengge = ''
      feiyong = ''
      xuanxiang = ''
      item["ID"]=p.ID
      item["案例名"]=p.NAME
      tag = p.tags
      for t in tag
        if t.TAGFATHERID==6687
          yanse += t.TAGNAME+"、"
        elsif t.TAGFATHERID==4347
          huxing += t.TAGNAME+"、"
        elsif t.TAGFATHERID==4352
          yongtu += t.TAGNAME+"、"
        elsif t.TAGFATHERID==4348
          fengge += t.TAGNAME+"、"
        elsif t.TAGFATHERID==4349
          feiyong += t.TAGNAME+"、"
        elsif t.TAGFATHERID==31262
          xuanxiang += t.TAGNAME+"、"
        else
        
        end
      end
      item["颜色"]=yanse
      item["户型"]=huxing
      item["装修用途"]=yongtu
      item["风格"]=fengge
      item["费用"]=feiyong
      item["特别选项"]=xuanxiang
      array << item
    end
    e = Excel::Workbook.new
    e.addWorksheetFromArrayOfHashes("核价单列表", array)
    headers['Content-Type'] = "application/vnd.ms-excel"
    headers['Content-Disposition'] = 'attachment; filename="hejiadan.xls"'
    headers['Cache-Control'] = ''
    render :text=>e.build
  end
#    return false unless pvalidate("导出核价单","管理员","核价组长","核价组员")
#    array = Array.new
#    pricings = Pricing.find :all,
#        :select => "id, name, brand, xinghao, num, price, priceetime, pricestime, smalltype, username, userid, proid, passtime, oldprice, priceunit, phone, email, hopeaddress, state, createtime, chulistate, checknum, executor, address",
#        :conditions => condition,
#        :order => "id desc"
#    for p in pricings
#      item = OrderedHash.new
#      item["编号"] = p.id
#      item["客户姓名"] = p.username
#      item["客户电话"] = p.phone
#      item["日期"] = p.createtime.strftime("%Y-%m-%d %H:%M")
#      item["产品名称"] = p.name
#      item["品牌"] = p.brand
#      item["型号"] = p.xinghao
#      item["希望购买地"] = p.hopeaddress
#      item["数量"] = p.num
#      item["状态"] = HEJIA_STATE[p.chulistate]
#      item["处理人员"] = p.user.rname rescue ""
#      item["招商1"] = p.pricing_bill.zhaoshang rescue ""
#      item["价格1"] = p.pricing_bill.sendprice rescue ""
#      item["招商2"] = p.pricing_bill.zhaoshang2 rescue ""
#      item["价格2"] = p.pricing_bill.sendprice2 rescue ""
#      item["短信"] = p.pricing_bill.result rescue ""
#      item["备注"] = p.pricing_bill.beizhu rescue ""
#      array << item
#    end
#    e = Excel::Workbook.new
#    e.addWorksheetFromArrayOfHashes("核价单列表", array)
#    headers['Content-Type'] = "application/vnd.ms-excel"
#    headers['Content-Disposition'] = 'attachment; filename="hejiadan.xls"'
#    headers['Cache-Control'] = ''
#    render :text=>e.build
#  end

#      if (tag.getTag().getTagFatherid().equals(new Long(6687))) {
#						yanse += tag.getTag().getTagName() + "、";
#					}
#					if (tag.getTag().getTagFatherid().equals(new Long(4347))) {
#						huxing += tag.getTag().getTagName() + "、";
#					}
#					if (tag.getTag().getTagFatherid().equals(new Long(4352))) {
#						yongtu += tag.getTag().getTagName() + "、";
#					}
#					if (tag.getTag().getTagFatherid().equals(new Long(4348))) {
#						fengge += tag.getTag().getTagName() + "、";
#					}
#					if (tag.getTag().getTagFatherid().equals(new Long(4349))) {
#						feiyong += tag.getTag().getTagName() + "、";
#					}
#					if (tag.getTag().getTagFatherid().equals(new Long(31262))) {
#						xuanxiang += tag.getTag().getTagName() + "、";
#					}
end
