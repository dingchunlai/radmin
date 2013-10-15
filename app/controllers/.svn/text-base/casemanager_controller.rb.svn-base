class CasemanagerController < ApplicationController
  def list
    @tagId1 = params[:tagId1]
    @tagId2 = params[:tagId2]
    @tagId3 = params[:tagId3]
    @tagId4 = params[:tagId4]
    @tagId5 = params[:tagId5]
    @tagId6 = params[:tagId6]
    @name = params[:name]
    con = " STATUS!='-100'"
    if !@tagId1.nil?&&@tagId1.to_s!=''
      con+=" and EXISTS (select * FROM HEJIA_TAG_ENTITY_LINK as link2 WHERE link2.TAGID = #{@tagId1} and link2.LINKTYPE='case' and link2.ENTITYID =HEJIA_CASE.ID)"
    end
    
    if !@tagId2.nil?&&@tagId2.to_s!=''
      con+=" and EXISTS (select * FROM HEJIA_TAG_ENTITY_LINK as link2 WHERE link2.TAGID = #{@tagId2} and link2.LINKTYPE='case' and link2.ENTITYID =HEJIA_CASE.ID)"
    end
    
    if !@tagId3.nil?&&@tagId3.to_s!=''
      con+=" and EXISTS (select * FROM HEJIA_TAG_ENTITY_LINK as link2 WHERE link2.TAGID = #{@tagId3} and link2.LINKTYPE='case' and link2.ENTITYID =HEJIA_CASE.ID)"
    end
    
    if !@tagId4.nil?&&@tagId4.to_s!=''
      con+=" and EXISTS (select * FROM HEJIA_TAG_ENTITY_LINK as link2 WHERE link2.TAGID = #{@tagId4} and link2.LINKTYPE='case' and link2.ENTITYID =HEJIA_CASE.ID)"
    end
    
    if !@tagId5.nil?&&@tagId5.to_s!=''
      con+=" and EXISTS (select * FROM HEJIA_TAG_ENTITY_LINK as link2 WHERE link2.TAGID = #{@tagId5} and link2.LINKTYPE='case' and link2.ENTITYID =HEJIA_CASE.ID)"
    end
    
    if !@tagId6.nil?&&@tagId6.to_s!=''
      con+=" and EXISTS (select * FROM HEJIA_TAG_ENTITY_LINK as link2 WHERE link2.TAGID = #{@tagId6} and link2.LINKTYPE='case' and link2.ENTITYID =HEJIA_CASE.ID)"
    end
    
    if !@name.nil? && @name != ''
      puts @name
      con+=" and NAME like '%#{@name.strip}%'  "
    end
    @caselist = DecoCase.paginate :page => params[:page], :per_page => 20,
    :conditions =>con ,
    :order => "ID desc"
  end
  
  def colorcreate
    
  end
  #  色卡保存
  def createsave
    color = params[:color]
    title = params[:title]
    colorimg = HejiaImgcolor.new
    colorimg.COLOR =color
    colorimg.NAME = title
    colorimg.STATUS = "0"
    colorimg.save
    redirect_to :action =>'colorcreate'
  end
  
  def colorlist
#    色卡列表
    @address = params[:address]
    @caseid = params[:caseid]
    @name = params[:name]
    colorid = params[:colorid]
    if !@address.nil?&&@address.to_s!=''
      create_link_color(@caseid,colorid,@address)
    end
    con=" NAME is not null AND COLOR is not null"
    if !@name.nil? && @name != ''
      puts @name
      con+=" AND NAME like '%#{@name.strip}%'  "
    end
    @color = HejiaImgcolor.paginate :page => params[:page], :per_page => 30,
    :conditions =>con
  end
  
  def casecolor
    #  选择色卡模板数
    @caseid = params[:id]
  end
  
  def casecolorsave
#    色卡模板保存
    @caseid = params[:caseid]
    id = params[:caseid]
    libangCount = params[:libangCount]
    puts libangCount
    c = DecoCase.find id, :select=>"ID as id, LIBANGCOUNT"
    c.LIBANGCOUNT=libangCount
    c.update_attributes(params[c])
    redirect_to :action =>'colorlist' ,:caseid => @caseid
  end
  
  def looks
#    预览色卡
    @id = params[:id]
    c = DecoCase.find(@id)
    @color = HejiaColorlink.find(:all,:conditions=>" CASEID=#{@id}",:order=>"ADDRESS asc")
    @count = c.LIBANGCOUNT
  end
  
  def create_link_color(id,colorid,address)
      link = HejiaColorlink.find(:first,:conditions=>" CASEID=#{id} and ADDRESS=#{address}")
      if !link.nil?
        puts link.ID
        HejiaColorlink.delete(link.ID)
      end
      colorlink = HejiaColorlink.new()
      image = HejiaImgcolor.find(colorid)
      colorlink.CASEID=id
      colorlink.COLORID = colorid
      colorlink.ADDRESS = address
      colorlink.NAME = image.NAME
      colorlink.COLOR = image.COLOR
      puts colorlink.CASEID
       puts colorlink.COLORID
        puts colorlink.ADDRESS
         puts colorlink.NAME
      colorlink.save
  end
  
  def checkall
    num = params[:num]
    ids = params[:ids]
    
    DecoCase.update_all("ischeck = #{num}","ID in (#{ids})")
    
    render :text => "操作成功"
  end
end
