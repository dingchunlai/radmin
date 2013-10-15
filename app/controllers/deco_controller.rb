class DecoController < ApplicationController
  require "ftools"
  
  before_filter :member_validate, :find_firm #验证用户身份

  uses_tiny_mce :options => {
    :language => 'zh',
    :theme => 'advanced',
    #:width => "760px",
    :convert_urls => false,
    :relative_urls => false,
    :visual => false,
    :theme_advanced_buttons1 => "bold,italic,underline,strikethrough,|,justifyleft,justifycenter,justifyright,justifyfull,|,bullist,numlist,|,formatselect,fontselect,fontsizeselect,|,outdent,indent,blockquote,|,undo,redo",
    :theme_advanced_buttons2 => "tablecontrols,|,hr,removeformat,visualaid,code |,hr,removeformat,visualaid,|,link,unlink,anchor,image,upload,cleanup,|,forecolor,backcolor,code",
    :theme_advanced_buttons3 => "",
    :theme_advanced_resizing => false,
    :theme_advanced_resize_horizontal => false,
    :theme_advanced_toolbar_location => "top",
    :theme_advanced_toolbar_align => "left",
    :theme_advanced_statusbar_location => "bottom",
    :plugins => %w{ table fullscreen upload}
  }#,:only => [:new, :create, :edit, :update]
  $formid=PINGLUN_ID
  $replyid=88
  def factory_list
    h = Hash.new
    h["model"] = DecoFactory
    h["pagesize"] = 12 #每页记录数
    h["listsize"] = 10 #同时显示的页码数
    h["select"] = "ID as id,FANGXING,PROVINCE1,PROVINCE2,NAME,`CONDITION`,STYLE,MONEY,STARTENABLE,ENDENABLE"
    h["conditions"] = "COMPANYID = #{deco_company_id}"
    h["order"] = "LIST_INDEX desc,ID desc"
    @factorys = paging_record(h)
    @city = get_cities
  end

  def designer_list
    h = Hash.new
    h["model"] = DecoDesigner
    h["pagesize"] = 14 #每页记录数
    h["listsize"] = 10 #同时显示的页码数
    h["select"] = "ID as id, DESNAME, DESFEE, DESAGE, DESTEL, DESSCHOOL, DESSTYLE, DESRESUME, PICURL"
    h["conditions"] = "COMPANY = #{deco_company_id} and (STATUS!='-100' or STATUS is null)"
    h["order"] = "LIST_INDEX desc"
    @designers = paging_record(h)
  end

  def sort
    order_number = 999
    order_array = params[:designers] || params[:cases] || params[:factory_datalist]
    order_array.each do |id|
      DecoDesigner.update_all("LIST_INDEX = #{order_number}",:ID=>id) if params[:designers]
      DecoCase.update_all("LIST_INDEX = #{order_number}",:ID=>id) if params[:cases]
      DecoFactory.update_all("LIST_INDEX = #{order_number}",:ID=>id) if params[:factory_datalist]
      order_number -= 1
    end
    render :nothing => true
  end

  def case_list
    if !params[:page]
      session[:item] = nil
      @tagId1 = params[:tagId1]
      @tagId2 = params[:tagId2]
      @tagId3 = params[:tagId3]
      @tagId4 = params[:tagId4]
      @tagId5 = params[:tagId5]
      @tagId6 = params[:tagId6]
      @name = params[:name]
      @status = nil
      @item = []
      @item << @tagId1
      @item << @tagId2
      @item << @tagId3
      @item << @tagId4
      @item << @tagId5
      @item << @tagId6
      @item << @name
      @item << @status
      session[:item] = @item
    else
      @item = session[:item]
      @tagId1 = @item[0]
      @tagId2 = @item[1]
      @tagId3 = @item[2]
      @tagId4 = @item[3]
      @tagId5 = @item[4]
      @tagId6 = @item[5]
      @name = @item[6]
      @status = @item[7]
    end
    con =  "(COMPANYID = #{deco_company_id} "

    if deco_company_id == '7'
      con+= " or COMPANYID = 0 or COMPANYID is null) and  STATUS <> '-100'"
    else
      con+= ") and ISCOMMEND = 0 and STATUS <> '-100'"
    end
    cas = " and EXISTS (select * FROM HEJIA_TAG_ENTITY_LINK as link2 WHERE link2.TAGID = "
    ase = " and link2.LINKTYPE='case' and link2.ENTITYID =HEJIA_CASE.ID)"

    if !@tagId1.nil?&&@tagId1.to_s!=''
      con+= cas + "#{@tagId1}" + ase;
    end

    if !@tagId2.nil?&&@tagId2.to_s!=''
      con+= cas + "#{@tagId2}" + ase
    end

    if !@tagId3.nil?&&@tagId3.to_s!=''
      con+= cas + "#{@tagId3}" + ase
    end

    if !@tagId4.nil?&&@tagId4.to_s!=''
      con+= cas + "#{@tagId4}" + ase
    end

    if !@tagId5.nil?&&@tagId5.to_s!=''
      con+= cas + "#{@tagId5}" + ase
    end

    if !@tagId6.nil?&&@tagId6.to_s!=''
      con+= cas + "#{@tagId6}" + ase
    end

    if !@name.nil? && @name != ''
      con+=" and NAME like '%#{@name.strip}%'  "
    end

    if !@status.nil? && @status != ''
      con+=" and STATUS='#{@status.strip}'  "
    end
    commmm = cookies[:editer_id]
    @back = cookies[:back]
    h = Hash.new
    h["model"] = DecoCase
    h["pagesize"] = 14 #每页记录数
    h["listsize"] = 10 #同时显示的页码数
    h["select"] = "ID as id,ID, NAME, COMPANYID, INTRODUCE, STATUS, DESIGNERID, ISNEWCASE, ISCHOICENESS, ISCOMMEND, ISZHUANGHUANG, CREATEDATE,REPORTERID, is_recommend"
    h["conditions"] = con
    if deco_company_id == '7'
      h["order"] = "ID desc"
    else
      h["order"] = "LIST_INDEX desc"
    end
    @cases = paging_record(h)
    
  end


  def image_list #装修实图列表
    @case_id = params[:id]
    h = Hash.new
    h["model"] = PhotoPhoto
    h["pagesize"] = 6 #每页记录数
    h["listsize"] = 10 #同时显示的页码数
    h["select"] = "id, filepath, description, case_id,flow_status"
    h["conditions"] = "case_id = #{params[:id]}"
    h["order"] = "id asc"
    @images = paging_record(h)
    img_ids = "0"
    for img in @images
      img_ids += "," + img.id.to_s
    end
    @tagids = Hash.new
    @tagnames = Hash.new
    if img_ids != "0"
      all_tagids = "0"
      tagids = PhotoPhotosTag.find :all, :select=>"photo_id, tag_id as TAGID", :conditions=>"type_id = 1 and photo_id in (#{img_ids})"
      for tagid in tagids
        @tagids[tagid.photo_id] = "0" if @tagids[tagid.photo_id].nil?
        @tagids[tagid.photo_id.to_i] += ("," + tagid.TAGID.to_s)
        all_tagids += ("," + tagid.TAGID.to_s)
      end
      tagnames = PhotoTag.find :all, :select=>"id as TAGID, name as TAGNAME", :conditions=>"id in (#{all_tagids})"
      for t in tagnames
        @tagnames[t.TAGID.to_i] = t.TAGNAME
      end
    end
  end


  def extract_label
    #Regional区域
    @tag1 = Tag.find(:all, :select => "tagid,tagname", :conditions => "tagfatherid = 4388  and TAGESTATE != -1")
    #Color颜色
    @tag2 = Tag.find(:all, :select => "tagid,tagname", :conditions => "tagfatherid = 6694  and TAGESTATE != -1")
    #Regional product区域产品
    @tag3 = Tag.find(:all, :select => "tagid,tagname", :conditions => "tagfatherid = 6703  and TAGESTATE != -1")
    #Picture Properties图片属性
    @tag4 = Tag.find(:all, :select => "tagid,tagname", :conditions => "tagfatherid = 41811 and TAGESTATE != -1")
    #style风格
    @tag5 = Tag.find(:all, :select => "tagid,tagname", :conditions => "tagfatherid = 41891 and TAGESTATE != -1")
  end

  def image_edit
    @back = cookies[:back]
    @coo = deco_company_id.to_s
    @id = getint(params[:id])
    extract_label
    @tagids = Array.new

    if @id == 0
      @img = PhotoPhoto.new
    else
      @img = PhotoPhoto.find(:first, :select=>"id, filepath, filename, case_id,description", :conditions => "id = #{@id}")
      photoTags = PhotoPhotosTag.find(:all, :select => "tag_id,type_id", :conditions => "photo_id = #{@id}")
      unless photoTags.nil?
        imageHandTagArray=Array.new
        for phoTag in photoTags
          imageHandTagArray << PhotoTag.get_name_by_id(phoTag.tag_id)  if(phoTag.type_id==2)
          photo_tag_name = PhotoTag.find(:first, :select => "name", :conditions => ["id = ?" , phoTag.tag_id.to_s])
          tagid = Tag.find(:first, :select => "TAGID", :conditions => [" TAGNAME = ? and TAGFATHERID in (4388,6694,6703,41811,41891) and TAGESTATE != -1",photo_tag_name.name.to_s])
          @tagids << tagid.TAGID.to_s unless tagid.nil?
        end
        @imageHandTags=imageHandTagArray.join(" ")
      end
    end
  end

  #Single-image changes
  def image_edit_save
    id = getint(params[:id])
    caseid = getint(params[:caseid])
    description = params[:description]
    begin
      if params["photo"]["uploaded_data"].size/1024>100
        rt = alert("操作失败：图片不可以大于100K")
      else
        PhotoPhotosTag.delete_all "photo_id = #{id}"
        if params["photo"]["uploaded_data"]==""
          PhotoPhoto.update(id, :description=>description)
        else
          @new_photo = PhotoPhoto.new(params["photo"])
          if @new_photo.save
            PhotoPhoto.delete_all "id = #{id} or parent_id = #{id}"
            filepath = Time.now.strftime("%Y%m%d").to_s+"/"+@new_photo.filename
            id = @new_photo.id
            master_map = PhotoPhoto.find(:first, :conditions => ["case_id = ? and flow_status = ?" , caseid,caseid])
            to_determine_the_main_map(master_map,id,filepath,description,caseid)
          end
        end
        hand_tags=params[:imageHandTags]
        if((!hand_tags.nil?)&&(trim(hand_tags).size>0))
          hand_tags = hand_tags.gsub(","," ").gsub(";"," ").gsub("，"," ").gsub("；"," ").gsub("  "," ")
          hand_tags = trim(hand_tags).split(" ")
          hand_photo_tags(hand_tags, id)
        end
        common_photo_tags(params[:tag1],params[:tag2],params[:tag3],params[:tag4],params[:tag5],id)
      end

    rescue Exception => e
      rt = alert("操作失败：#{get_error(e)}")
    end

    PHOTO_CACHE.set("key_photo_show_hejia_case_#{caseid}",nil)
    PHOTO_CACHE.set("key_photo_show_photos_tag_#{caseid}",nil)
    render_text = js(top_load("/deco/image_list?id=#{caseid}&page=#{params[:page]||1}"))
    render_text = rt + render_text unless rt.blank?
    render :text => render_text
  end


  #Bulk Upload Map
  def image_add
    @back = cookies[:back]
    
    if staff_logged_in?
      @login_type = 1  #管理员登录
    else
      @login_type = 2 #如果cookie没中有管理员信息 则判断普通商家登录
    end
    @coo = deco_company_id.to_s
    @id = getint(params[:id])
    extract_label
  end


  #Batch Add a picture
  def image_add_save
    caseid = getint(params[:caseid])
    description = params[:description]
    file_size = params[:file_size]
    cout=""
    1.upto(file_size.to_i) do |i|
      if params["photo#{i}"]["uploaded_data"] != ""
        if params["photo#{i}"]["uploaded_data"].size/1024>100
          cout += " "+i.to_s + " "
        else
          @new_photo = PhotoPhoto.new(params["photo#{i}"])
          if @new_photo.save
            filepath = Time.now.strftime("%Y%m%d").to_s+"/"+@new_photo.filename 
          end
          id = @new_photo.id
          master_map = PhotoPhoto.find(:first, :conditions => ["case_id = ? and flow_status = ?" , caseid,caseid])
          #判断主图是否存在
          to_determine_the_main_map(master_map,id,filepath,description,caseid)
          #手动标签的添加
          hand_tags=params[:imageHandTags]
          if((!hand_tags.nil?)&&(trim(hand_tags).size>0))
            hand_tags = hand_tags.gsub(","," ").gsub(";"," ").gsub("，"," ").gsub("；"," ").gsub("  "," ")
            hand_tags = trim(hand_tags).split(" ")
            hand_photo_tags(hand_tags, id)
          end
          #添加图片与标签关系
          common_photo_tags(params[:tag1],params[:tag2],params[:tag3],params[:tag4],params[:tag5],id)
        end
      end
    end
    $rd = nil
    if cout != ""
      render :text => js("if (confirm('第#{cout}图片上传失败，图片大小超过100KB   继续录入图片(确定)/(取消)返回列表')){window.open('/deco/image_add?caseid=#{caseid}','_top');}else{window.open('/deco/image_list?id=#{caseid}','_top');}")
    else
      render :text => js("window.open('/deco/image_list?id=#{caseid}','_top');")
    end
  end

  #判断主图是否存在
  def to_determine_the_main_map(master_map,id,filepath,description,caseid)
    unless master_map.nil?
      PhotoPhoto.update(id,{:filepath=>filepath, :description=>description, :case_id=>caseid, :type_id=>3})
    else
      #      PhotoPhoto.update_all("flow_status = null", "case_id=#{case_id}")
      PhotoPhoto.update(id,{:filepath=>filepath, :description=>description, :case_id=>caseid, :type_id=>3, :flow_status => caseid})
      photo = PhotoPhoto.find(id)
      set_image_main(caseid, photo)
      #修改的地方
      #start
      #      way = truncate(filepath,0,8)
      #      if truncate(filepath,32,10).length.to_i > 2
      #        way1 = truncate(filepath,9,23)
      #      else
      #        way1 = truncate(filepath,9,21)
      #      end
      #      if truncate(filepath,32,10).length.to_i > 2
      #        way=way+"/tn/"+way1+"_s"+truncate(filepath,32,10)
      #      else
      #        way=way+"/tn/"+way1+"_s"+truncate(filepath,30,10)
      #      end
      #      path = "#{RAILS_ROOT}/public/files/hekea/case_img/"+way.to_s
      #      if path.include?(".jpg")
      #        filepath = "#{RAILS_ROOT}/public/files/hekea/case_img/tn/"+caseid.to_s+".jpg"
      #      end
      #      if path.include?(".gif")
      #        filepath = "#{RAILS_ROOT}/public/files/hekea/case_img/tn/"+caseid.to_s+".gif"
      #      end
      #      if path.include?(".png")
      #        filepath = "#{RAILS_ROOT}/public/files/hekea/case_img/tn/"+caseid.to_s+".png"
      #      end
      #      if path.include?(".bmp")
      #        filepath = "#{RAILS_ROOT}/public/files/hekea/case_img/tn/"+caseid.to_s+".bmp"
      #      end
      #      FileUtils.copy_file(path,  filepath)
      #end
    end
  end

  def hand_photo_tags(tags,photoId,typeid=2)
    unless tags.nil?
      tags.each do |tagname|
        comm_photo_tag(photoId,tagname,typeid)
      end
    end
  end

  #添加图片与标签关系
  def common_photo_tags(tag1,tag2,tag3,tag4,tag5,emptyid)
    unless tag1.nil?
      tag1.each do |tagname|
        comm_photo_tag(emptyid,tagname,1)
      end
    end
    unless tag2.nil?
      tag2.each do |tagname|
        comm_photo_tag(emptyid,tagname,0)
      end
    end
    unless tag3.nil?
      tag3.each do |tagname|
        comm_photo_tag(emptyid,tagname,0)
      end
    end
    unless tag4.nil?
      tag4.each do |tagname|
        comm_photo_tag(emptyid,tagname,0)
      end
    end
    unless tag5.nil?
      tag5.each do |tagname|
        comm_photo_tag(emptyid,tagname,0)
      end
    end
  end
  #add tag code
  def comm_photo_tag(emptyid,tagname,typeid)
    # tag_name = Tag.find(:first, :select => "TAGNAME", :conditions => [" TAGID = ? and TAGFATHERID in (4388,6694,6703,41811,41891) and TAGESTATE != -1",tagid.to_s ])
    photo_tag_id = PhotoTag.find(:first, :select => "id", :conditions => ["name = ?" , tagname])
    if photo_tag_id.nil?
      ptl = PhotoTag.new()
      ptl.name = tagname.to_s
      ptl.created_at = getnow()
      ptl.updated_at = getnow()
      ptl.save
      photo_tag_id = PhotoTag.find(:first, :select => "id", :order => "id desc")
    end
    create_photo_tags_link(emptyid, photo_tag_id.id,typeid)
  end

  def house_list #户型图列表
    h = Hash.new
    h["model"] = DecoHouse
    h["pagesize"] = 6 #每页记录数
    h["listsize"] = 10 #同时显示的页码数
    h["select"] = "ID as id, IMAGENAME, INTRODUCE, CASEID, IMAGETYPE"
    h["conditions"] = "CASEID = #{params[:id]}"
    h["order"] = "ID desc"
    @houses = paging_record(h)
  end

  def house_edit
    @id = getint(params[:id])
    if @id == 0
      @house = DecoHouse.new
    else
      @house = DecoHouse.find @id,
        :select=>"ID as id, IMAGENAME, INTRODUCE, CASEID, IMAGETYPE"
    end
  end

  def house_edit_save
    id = getint(params[:id])
    caseid = getint(params[:caseid])
    house = params[:house]
    filename = get_file(params[:imagename], "/uploads/deco_house/")
    house["IMAGENAME"] = filename unless filename.nil?
    begin
      if id == 0
        house["CASEID"] = caseid
        ar = DecoHouse.new(house)
        ar.save
        rt = alert("操作成功：记录已创建!") + js(top_load("self"))
      else
        ar = DecoHouse.find id, :select=>"ID as id, IMAGENAME, INTRODUCE, CASEID, IMAGETYPE"
        ar.update_attributes(house)
        rt = alert("操作成功：信息已修改!") + js(top_load("self"))
      end
    rescue Exception => e
      rt = alert("操作失败：#{get_error(e)}")
    end
    render :text => rt
  end

  def factory_edit
    @cities = get_cities
    @id = getint(params[:id])
    if @id == 0
      @factory = DecoFactory.new
      @factory.PROVINCE2 = 0
      @factory.PROVINCE1 = 11910
      @areas = get_areas2(11910)
    else
      @factory = DecoFactory.find @id,
        :select=>"ID as id,FANGXING,PROVINCE1,PROVINCE2,NAME,`CONDITION`,STYLE,MONEY,STARTENABLE,ENDENABLE"
      @factory.STARTENABLE = @factory.STARTENABLE.strftime("%Y-%m-%d") rescue ""
      @factory.ENDENABLE = @factory.ENDENABLE.strftime("%Y-%m-%d") rescue ""
      @areas = get_areas2(@factory.PROVINCE1)
      @fangxing = @factory.FANGXING
    end
  end

  def factory_edit_save
    id = getint(params[:id])
    params[:factory][:FANGXING] = FACTORY_FANGXING[params[:factory][:FANGXING].to_i]
    factory = params[:factory]
    begin
      if id == 0
        factory["COMPANYID"] = deco_company_id
        f = DecoFactory.new(factory)
        f.save       
      else
        f = DecoFactory.find id, :select=>"ID as id,FANGXING,PROVINCE1,PROVINCE2,NAME,`CONDITION`,STYLE,MONEY,STARTENABLE,ENDENABLE"
        f.update_attributes(factory)
      end
      render :text => js("if (confirm('操作成功：记录已创建/修改!')){window.open('/deco/factory_list','_top');}")
    rescue Exception => e
      render :text => alert_error("操作失败：#{get_error(e)}")
    end
  end

  def designer_edit
    @paixu =Hash.new
    @paixu = ["100","200","300","400","500","600","700","800","900"]
    @back = cookies[:back]
    @id = getint(params[:id])
    @bbs = nil
    if @id == 0
      @designer = DecoDesigner.new
    else
      @bbs = HejiaUserBbs.find(:first,:conditions => "ISDEL=1 and USERTYPE='100' and BBSID=#{@id}" )
      @designer = DecoDesigner.find @id,
        :select=>"ID as id, DESNAME, DESFEE, DESAGE, DESTEL, DESSCHOOL, DESSTYLE, DESRESUME, PICURL, STATUS,GLORY,GRADE,POSITION"
      @desstyle = @designer.DESSTYLE.split(",") rescue nil
      @picurl = @designer.PICURL
      @designer["DESAGE"] = @designer.DESAGE.to_i
      @designer["DESFEE"] = @designer.DESFEE.to_i
      @designer
    end
  end

  def designer_edit_save
    id = getint(params[:id])
    designer = params[:designer]
    grade = params[:grade]
    if params[:PICURL].size/1024>100
      render :text => alert("操作失败：上传图片不能超过100K")
    else
      filename = get_file(params[:PICURL], "/files/designer/")
      designer["PICURL"] = filename unless filename.nil?
      designer["DESSTYLE"] = params[:DESSTYLE].join(",") rescue ""
      designer["GRADE"] = grade
      begin
        hub = HejiaUserBbs.new
        decofirm = DecoFirm.find(deco_company_id)
        if id == 0
          designer["COMPANY"] = deco_company_id
          designer["STATUS"] = "100"
          designer["UPDATE_TIME"] = Time.now.to_s(:db)
          designer["LIST_INDEX"] = 1000
          ar = DecoDesigner.new(designer)
          ar.save
          hub.deco_id = deco_company_id
          hub.AREA = decofirm.city
          hub.CITY = decofirm.district
          hub.USERTYPE = '100'
          hub.ISDEL=1
          hub.CREATTIME = Time.now
          #设计师相关
          hub.BBSID = ar.id
          hub.USERBBSNAME = ar.DESNAME #设计师名 DESNAME
          hub.USERBBSADDRESS = ar.DESFEE #收费标准 DESFEE
          hub.USERBBSCODE = ar.DESAGE #从业年限 DESAGE
          hub.USERBBSEMAIL = ar.DESSTYLE #擅长风格 DESSTYLE
          hub.USERBBSTEL = ar.DESTEL#联系电话 DESTEL
          hub.USERBBSSEX = ar.DESSCHOOL #毕业学校 DESSCHOOL
          hub.ROLEADMIN =  ar.GRADE#级别 GRADE
          hub.MSN = ar.POSITION #职位 POSITION
          hub.USERBBSROLE = ar.GLORY #荣誉 GLORY
          hub.USERBBSREADME = ar.DESRESUME #s设计师简介 DESRESUME
          hub.REPAIRENJOY = ar.STATUS #排序码 STATUS
          hub.HEADIMG = ar.PICURL #图片地址 PICURL
          hub.save
          new_count = decofirm.designers_count.to_i + 1
          decofirm.update_attribute("designers_count",new_count )
          #
          render :text => alert("操作成功：记录已创建!") + js(top_load("self"))
        else
          ar = DecoDesigner.find id, :select=>"ID as id, DESNAME, DESFEE, DESAGE, DESTEL, DESSCHOOL, DESSTYLE, DESRESUME, PICURL, STATUS,GLORY,GRADE,POSITION,UPDATE_TIME"
          designer["UPDATE_TIME"] = Time.now.to_s(:db)
          ar.update_attributes(designer)
          @bbs = HejiaUserBbs.find(:first,:conditions => "ISDEL=1 and USERTYPE='100' and BBSID=#{ar.id}" )
          if @bbs.nil?
            hub.deco_id = deco_company_id
            hub.AREA = decofirm.city
            hub.CITY = decofirm.district
            hub.USERTYPE = '100'
            hub.ISDEL=1
            hub.CREATTIME = Time.now
            #设计师相关
            hub.BBSID = ar.id
            hub.USERBBSNAME = ar.DESNAME #设计师名 DESNAME
            hub.USERBBSADDRESS = ar.DESFEE #收费标准 DESFEE
            hub.USERBBSCODE = ar.DESAGE #从业年限 DESAGE
            hub.USERBBSEMAIL = ar.DESSTYLE #擅长风格 DESSTYLE
            hub.USERBBSTEL = ar.DESTEL#联系电话 DESTEL
            hub.USERBBSSEX = ar.DESSCHOOL #毕业学校 DESSCHOOL
            hub.ROLEADMIN =  ar.GRADE#级别 GRADE
            hub.MSN = ar.POSITION #职位 POSITION
            hub.USERBBSROLE = ar.GLORY #荣誉 GLORY
            hub.USERBBSREADME = ar.DESRESUME #s设计师简介 DESRESUME
            hub.REPAIRENJOY = ar.STATUS #排序码 STATUS
            hub.HEADIMG = ar.PICURL #图片地址 PICURL
            hub.save
          else
          end
          render :text => alert("操作成功：信息已修改!") + js(top_load("self"))
        end
      rescue Exception => e
        render :text => alert("操作失败：#{get_error(e)}")
      end
    end
    #end
  end

  #add or edit CaseBaseInfo show
  def case_edit
    @cities = get_cities
    @back = staff_logged_in?
    @id = params[:id].to_i
    @tag1 = DecoInfo.find(:all, :select => "tagid,tagname", :from => "HEJIA_TAG", :conditions => "tagfatherid = 4350 and TAGESTATE!='-1'")#装修方式
    @tag2 = DecoInfo.find(:all, :select => "tagid,tagname", :from => "HEJIA_TAG", :conditions => "tagfatherid = 4349 and TAGESTATE!='-1'")#费用
    @tag3 = DecoInfo.find(:all, :select => "tagid,tagname", :from => "HEJIA_TAG", :conditions => "tagfatherid = 4348 and TAGESTATE!='-1'")#风格
    @tag4 = DecoInfo.find(:all, :select => "tagid,tagname", :from => "HEJIA_TAG", :conditions => "tagfatherid = 4352 and TAGESTATE!='-1'")#装修用途
    @tag5 = DecoInfo.find(:all, :select => "tagid,tagname", :from => "HEJIA_TAG", :conditions => "tagfatherid = 4347 and TAGESTATE!='-1'")#户型
    @tag6 = DecoInfo.find(:all, :select => "tagid,tagname", :from => "HEJIA_TAG", :conditions => "tagfatherid = 6687 and TAGESTATE!='-1'")#颜色
    # add by sueg for new case manager
    @teshu = DecoInfo.find(:all, :select => "tagid,tagname", :from => "HEJIA_TAG", :conditions => "tagfatherid = 31262 and TAGESTATE!='-1'")#特别选项
    @jiaju = DecoInfo.find(:all, :select => "tagid,tagname", :from => "HEJIA_TAG", :conditions => "tagfatherid = 30885 and TAGESTATE!='-1'")#家居类别
    @anli = DecoInfo.find(:all, :select => "tagid,tagname", :from => "HEJIA_TAG", :conditions => "tagfatherid = 4401 and TAGESTATE!='-1'")#案例类别
    @zixun = DecoInfo.find(:all, :select => "tagid,tagname", :from => "HEJIA_TAG", :conditions => "tagfatherid = 9079 and TAGESTATE!='-1'")#资讯案例
    @leibie = DecoInfo.find(:all, :select => "tagid,tagname", :from => "HEJIA_TAG", :conditions => "tagfatherid = 30885 and TAGESTATE!='-1'")#家居类别
    @chanpin = DecoInfo.find(:all, :select => "tagid,tagname", :from => "HEJIA_TAG", :conditions => "tagfatherid = 41662 and TAGESTATE!='-1'")#产品
    @gonggongkongjian = DecoInfo.find(:all, :select => "tagid,tagname", :from => "HEJIA_TAG", :conditions => "tagfatherid = 42160 and TAGESTATE!='-1'")#公共空间
    #end
    @tagids = Array.new
    @designers = Hash.new
    @designers["不选"] = 0
    designers = DecoDesigner.find :all, :select=>"ID as id, DESNAME", :conditions=> "COMPANY = #{deco_company_id} and status <> '-100'"
    for d in designers
      @designers[d.DESNAME] = d.id.to_i
    end
    
    @deco_company_id = deco_company_id
    #p "add and update caseInfo."

    if @id == 0
      if HejiaCase.find(:all,:conditions => ["COMPANYID= ? and EDITORID = ? and CREATEDATE > ? and CREATEDATE < ?","#{deco_company_id}","#{current_user.USERBBSID}","#{Time.now.beginning_of_day.to_s(:db)}","#{Time.now.tomorrow.beginning_of_day.to_s(:db)}"]).size > 9 && !staff_logged_in?
        flash[:notice] = 'Sorry,您在今天新建案例已达到10条，请于24：00后进行创建'
        redirect_to "/deco/case_list"
      else
        @case = DecoCase.new
        @case["ISNEWCASE"] = 1
        @case["ISCHOICENESS"] = 0
        @case["ISCOMMEND"] = 0
        @case["ISZHUANGHUANG"] = 1
        @case["STATUS"] = 050
        @case["HUXINGORDER"] = 0
        @case["YUSUANORDER"] = 0
        @case["FENGGEORDER"] = 0
        @case["YONGTUORDER"] = 0
        @case["HOSTINFO"] = nil
        @case["BUILDINGNAME"] = nil
        @case["HOUSEAREA"] = nil
        @case["BUILDINGNAME"] = nil
        @case["address"] = nil
        @case["matrial"] = nil
        @case["LIST_INDEX"] = 1000
        @case["category"] = 0
        @areas = get_areas2(11910)
      end
    else
      @case = DecoCase.find @id,
        :select=>"ID as id, NAME, COMPANYID, INTRODUCE,HOSTINFO,BUILDINGNAME,HOUSEAREA, STATUS, DESIGNERID, ISNEWCASE, ISCHOICENESS, ISCOMMEND, ISZHUANGHUANG,HUXINGORDER,YUSUANORDER,FENGGEORDER,YONGTUORDER,BUILDINGNAME,address,PROVINCE2,matrial,PROVINCE1,category"
      tags = DecoInfo.find(:all,:select => "TAGID, STATE",:from => "HEJIA_TAG_ENTITY_LINK",
        :conditions => "ENTITYID = #{@id} and LINKTYPE = 'case'")
      hand_tags = []
      for tag in tags
        hand_tags << Tag.get_tagname_by_tagid(tag.TAGID) if tag.STATE.to_i == 2
      end
      @hand_tags = hand_tags.join(" ")
      @tagids = tags.collect { |r| r.TAGID  }
      @case["PROVINCE2"]  = @case["PROVINCE2"].to_s
      @case["ISNEWCASE"] = @case["ISNEWCASE"].to_i
      @case["ISCHOICENESS"] = @case["ISCHOICENESS"].to_i
      @case["ISCOMMEND"] = @case["ISCOMMEND"].to_i
      @case["ISZHUANGHUANG"] = @case["ISZHUANGHUANG"].to_i
      @case["category"] = @case["category"].to_i
      if @case.PROVINCE1.nil?
        @areas = get_areas2(11910)
      else
        @areas = get_areas2(@case.PROVINCE1)
      end
    end
    if params[:id]
      @case_detail = HejiaCase.find(params[:id]).case_detail
    else
      @case_detail = CaseDetail.new
    end
    
    
  end
  # add case page on click submit button after
  def case_edit_save
    case_id = params[:id].to_i
    c = params[:case]
    userid = cookies[:editer_id]
    @back = cookies[:back]
    begin
      if case_id == 0
        c["COMPANYID"] = deco_company_id
        c["COMPANYID"] = 7 if c["COMPANYID"] == 0
        c["CREATEDATE"] = getnow()
        c["STATUS"] = "050"
        c["ISCOMMEND"] = 0
        c["TEMPLATE"] = "real"
        c["LASTMODIFYTIME"] = getnow()
        if !userid.nil?
          c["REPORTERID"] = userid
        end
        c["EDITORID"] = current_user.USERBBSID unless current_user.blank?
        c.delete("DESIGNERID") if c["DESIGNERID"].blank?
        c["VIEWCOUNT"] = 300+rand(2700)
        c["CASEUP"] = 20+rand(180)
        c["CASEDOWN"] = 1+rand(9)
        ar = DecoCase.new(c)
        ar.save
            
        case_id = ar.id
        HejiaLog.save_log(current_staff.id, case_id, 7, 1) if current_staff #(user_id, entity_id, entity_type, event_id)
        rt = alert("操作成功：记录已创建!") + js(top_load("/deco/image_add?caseid=#{case_id}"))
      else
        ar = DecoCase.find case_id, :select=>"ID, NAME, COMPANYID, INTRODUCE,HOSTINFO,BUILDINGNAME,HOUSEAREA, STATUS, DESIGNERID, ISNEWCASE, ISCHOICENESS, ISCOMMEND, ISZHUANGHUANG,HUXINGORDER,YUSUANORDER,FENGGEORDER,YONGTUORDER,BUILDINGNAME,address,PROVINCE2,matrial,PROVINCE1,category,LASTMODIFYTIME"
        
        ar.update_attributes(c.update(:LASTMODIFYTIME =>Time.now.strftime("%Y-%m-%d %H:%M:%S")))
         
        # delete memcache
        PHOTO_CACHE.set("key_photo_show_hejia_case_#{case_id}",nil)
        PHOTO_CACHE.set("key_photo_show_photos_tag_#{case_id}",nil)
        HejiaTagLink.delete_all "ENTITYID = #{case_id} and LINKTYPE = 'case'"
        rt = alert("操作成功：信息已修改!") + js(top_load("/deco/image_add?caseid=#{case_id}"))
      end
      
      @case_detail = CaseDetail.find_by_hejia_case_id(ar.ID)

      if @case_detail.nil?
        params[:case_detail][:hejia_case_id] = ar.ID
        CaseDetail.create(params[:case_detail])
      else
        
        @case_detail.update_attributes(params[:case_detail])
      end

      unless params[:hand_tags].nil?
        hand_tags = params[:hand_tags].gsub(","," ").gsub(";"," ").gsub("，"," ").gsub("；"," ").gsub("  "," ")
        hand_tags = trim(hand_tags).split(" ")
        hand_tags.each do |tagname|
          tag_id = Tag.get_tagid_by_tagname(tagname)
          create_tag_link(case_id, tag_id, "case", 2) unless tag_id == 0
        end
      end
      create_tag_link(case_id, params[:tag1], "case") unless params[:tag1].nil?
      unless params[:tag2].nil?
        params[:tag2].each do |tagid|
          create_tag_link(case_id, tagid, "case")
        end
      end
      unless params[:tag3].nil?
        params[:tag3].each do |tagid|
          create_tag_link(case_id, tagid, "case")
        end
      end
      #      create_tag_link(id, params[:tag3], "case") usnless params[:tag3].nil?
      unless params[:tag4].nil?
        params[:tag4].each do |tagid|
          create_tag_link(case_id, tagid, "case")
        end
      end
      #      create_tag_link(id, params[:tag5], "case") unless params[:tag5].nil?
      unless params[:tag5].nil?
        params[:tag5].each do |tagid|
          create_tag_link(case_id, tagid, "case")
        end
      end
      unless params[:tag6].nil?
        params[:tag6].each do |tagid|
          create_tag_link(case_id, tagid, "case")
        end
      end
      unless params[:teshu].nil?
        params[:teshu].each do |tagid|
          create_tag_link(case_id, tagid, "case")
        end
      end
      create_tag_link(case_id, params[:anli], "case") unless params[:anli].nil?
      create_tag_link(case_id, params[:zixun], "case") unless params[:zixun].nil?

      unless params[:leibie].nil?
        params[:leibie].each do |tagid|
          create_tag_link(case_id, tagid, "case")
        end
      end

      unless params[:chanpin].nil?
        params[:chanpin].each do |tagid|
          create_tag_link(case_id, tagid, "case")
        end
      end

      unless params[:gonggongkongjian].nil?
        params[:gonggongkongjian].each do |tagid|
          create_tag_link(case_id, tagid, "case")
        end
      end
      
      
      
    rescue Exception => e
      rt = alert("操作失败：#{get_error(e)}")
    end
    render :text => rt
  end

  def designer_del
    begin
      unless params[:ids].nil?
        count = params[:ids].split(', ').size
        count -=1
        DecoDesigner.delete_all "id in (#{params[:ids]}) and COMPANY = #{deco_company_id}"
        decofirm = DecoFirm.find(deco_company_id)
        new_count = decofirm.designers_count.to_i - count
        decofirm.update_attribute("designers_count",new_count )
      end
      render :text => js(top_load("self"))
    rescue Exception => e
      render :text => alert_error("操作失败：#{get_error(e)}")
    end
  end

  def factory_del
    begin
      DecoFactory.delete(params[:id]) unless params[:id].nil?
      DecoFactory.delete_all "id in (#{params[:ids]}) and COMPANYID = #{deco_company_id}" unless params[:ids].nil?
      render :text => js(top_load("self"))
    rescue Exception => e
      render :text => alert_error("操作失败：#{get_error(e)}")
    end
  end

  def image_del
    begin
      PhotoPhoto.delete_all "id in (#{params[:ids]}) or parent_id in (#{params[:ids]})" unless params[:ids].nil?
      render :text => js(top_load("self"))
    rescue Exception => e
      render :text => alert_error("操作失败：#{get_error(e)}")
    end
  end

  def house_del
    begin
      DecoHouse.delete(params[:id]) unless params[:id].nil?
      DecoHouse.delete_all "id in (#{params[:ids]})" unless params[:ids].nil?
      render :text => js(top_load("self"))
    rescue Exception => e
      render :text => alert_error("操作失败：#{get_error(e)}")
    end
  end

  def case_del
    begin
      DecoCase.update_all("STATUS = '-100'", "id in (#{params[:ids]}) and COMPANYID = #{deco_company_id}") unless params[:ids].nil?
      render :text => js(top_load("self"))
    rescue Exception => e
      render :text => alert_error("操作失败：#{get_error(e)}")
    end
  end

  def case_recommend
    begin
      DecoCase.update_all("is_recommend = 1", "id in (#{params[:ids]}) and COMPANYID = #{deco_company_id}") unless params[:ids].nil?
      render :text => js(top_load("self"))
    rescue Exception => e
      render :text => alert_error("操作失败：#{get_error(e)}")
    end
  end

  def cancel_case_recommend
    begin
      DecoCase.update_all("is_recommend = 0", "id in (#{params[:ids]}) and COMPANYID = #{deco_company_id}") unless params[:ids].nil?
      render :text => js(top_load("self"))
    rescue Exception => e
      render :text => alert_error("操作失败：#{get_error(e)}")
    end
  end

  def decoinfo
    @back = cookies[:back]
    @deco = DecoInfo.find(deco_company_id, :select=>"ID,CN_NAME,ADDRESS,COMPANYAREA,COMPANYLOGO,TEL,BEGINBUSINESS,ENDBUSINESS,MSN,QQ,LINKMAN,`DESCRIBE`,ORDERID")
    @areas = get_areas
  end

  def decoinfo_save
    deco = params[:deco]
    filename = get_file(params[:logo_upload], "/uploads/logo/")
    deco["COMPANYLOGO"] = "/uploads/logo/#{filename}" unless filename.nil?
    d = DecoInfo.find(deco_company_id,:select=>"ID,CN_NAME,ADDRESS,COMPANYAREA,COMPANYLOGO,TEL,BEGINBUSINESS,ENDBUSINESS,MSN,QQ,LINKMAN,`DESCRIBE`,ORDERID")
    d.attributes = d.attributes.merge(deco)
    d.save_with_validation(false)
    render :text => alert("保存成功!") + js(top_load("self"))
  end

  def notice
    @deco = DecoNotice.find(:first, :select => "ID,INFO", :conditions => "ID = #{deco_company_id}")
  end

  def notice_save
    deco = params[:deco]
    d = DecoNotice.find(:first, :select => "ID as id, INFO", :conditions => "ID = #{deco_company_id}")
    if !d.nil?
      d.update_attributes(deco)
    else
      deco["INFO"]
      dec = DecoNotice.new
      dec.INFO = deco["INFO"]
      dec.ID = deco_company_id
      dec.save
    end
    render :text => alert("保存成功!")
  end

  def get_areas #取得上海区域Hash
    as = DecoInfo.find(:all, :select => "tagid,tagname", :from => "HEJIA_TAG", :conditions => "tagfatherid = 11910")
    areas = Hash.new
    areas[0] = "请选择"
    as.each do |a|
      areas[a.tagid.to_i] = a.tagname
    end
    return areas
  end

  def get_country_areas #取得上海区域Hash
    as = DecoInfo.find(:all, :select => "tagid,tagname", :from => "HEJIA_TAG", :conditions => "tagfatherid = 11910")
    areas = Hash.new
    areas[0] = "请选择"
    as.each do |a|
      areas[a.tagid.to_i] = a.tagname
    end
    return areas
  end

  def truncate(filepath,first,max)
    if filepath.nil? then return end
    chars = filepath.split(//)
    if chars.length>max
      str = chars[first.to_i,max.to_i].to_s
      return str
    else
      return filepath
    end
  end
  def image_copy
    case_id = params[:case_id]
    id = params[:id]
    photo = PhotoPhoto.find(id)
    photo.flow_status = case_id.to_s
    PhotoPhoto.update_all("flow_status = null", "case_id=#{case_id}")
    photo.update_attributes(params[:photo])
    set_image_main(case_id,photo)
    redirect_to :action => :image_list, :id => case_id
  end


  def photo
    @photo = CompanyPhoto.find(:all,:conditions =>"ENTITYID=#{deco_company_id}")
  end

  def photo_save
    entityid = deco_company_id
    entity_type="company"
    state="common"
    demonstration="yes"
    1.upto(5) do |i|
      comanyphoto = CompanyPhoto.new

      if strip(params["photo_#{i}"][:uploaded_data].to_s) == ""

      else
        comanyphoto.STATE = state
        comanyphoto.DEMONSTRATION = demonstration
        comanyphoto.ENTITYID = entityid
        comanyphoto.ENTITYTYPE = entity_type
        file = params["photo_#{i}"][:uploaded_data]
        content = params["photo_content_#{i}"]
        uploadFile(file,nil)
        comanyphoto.CONTENT = content
        comanyphoto.IMAGENAME = @filename
        puts @filename
        comanyphoto.save
      end
    end
    redirect_to :action => :photo
  end

  def photo_delte
    photo = CompanyPhoto.find(params[:id])
    @filename = photo.IMAGENAME
    File.delete("#{RAILS_ROOT}/public/files/hekea/companyphoto_img/#{@filename}") if File.exist?("#{RAILS_ROOT}/public/files/hekea/companyphoto_img/#{@filename}")
    photo.destroy
    redirect_to :action => :photo
  end

  def photo_edit
    @photo = CompanyPhoto.find(params[:id])
  end

  def phot_edit_save
    photo = CompanyPhoto.find(params[:id])
    fname = photo.IMAGENAME
    if strip(params["photoimg"][:uploaded_data].to_s) == ""

    else

      file = params["photoimg"][:uploaded_data]
      @message="上传图片不能大于500K"
      uploadFile(file,fname)
    end
    photo.CONTENT = params[:content]
    photo.update_attributes(params[photo])
    redirect_to "/deco/photo"
  end
  #上传文件相关
  def getFileName(file)
    Time.now.strftime("%Y%m%d").to_s+Time.now.to_i.to_s+file.original_filename
  end

  def uploadFile(file,fname)
    if fname && fname != ''
      @filename=fname
    else
      @filename=getFileName(file)
    end
    base_dir = "#{RAILS_ROOT}/public/files/hekea/companyphoto_img/"
    FileUtils.mkdir_p base_dir unless File.directory?(base_dir)
    File.delete("#{RAILS_ROOT}/public/files/hekea/companyphoto_img/#{@filename}") if File.exist?("#{RAILS_ROOT}/public/files/hekea/companyphoto_img/#{@filename}")
    File.open("#{RAILS_ROOT}/public/files/hekea/companyphoto_img/#{@filename}", "wb") do |f|
      f.write(file.read)
    end

    return @filename

  end

  def shop
    @shop = CompanyShop.find(:all,:conditions => "COMPANYID=#{deco_company_id}")
    @areas = get_areas
  end

  def shop_save
    companyshop = CompanyShop.new
    companyid = deco_company_id
    address = params[:address]
    shopName = params[:shopName]
    shopTel = params[:shopTel]
    shopFax = params[:shopFax]
    shopAdd = params[:shopAdd]
    shopContact = params[:shopContact]
    companyshop.SHOPADD = shopAdd
    companyshop.SHOPCONTACT = shopContact
    companyshop.SHOPFAX = shopFax
    companyshop.SHOPNAME = shopName
    companyshop.SHOPTEL = shopTel
    companyshop.COMPANYID = companyid
    companyshop.ADDRESS = address
    puts companyid
    companyshop.save
    redirect_to "/deco/shop"
  end

  def shop_del
    companyshop = CompanyShop.find(params[:id])
    companyshop.destroy
    redirect_to "/deco/shop"
  end

  def shop_edit
    @shopid=params[:id]
    @areas = get_areas
    @companyshop = CompanyShop.find(params[:id])
  end

  def shop_edit_save
    companyshop = CompanyShop.find(params[:id])
    address = params[:address]
    shopName = params[:shopName]
    shopTel = params[:shopTel]
    shopFax = params[:shopFax]
    shopAdd = params[:shopAdd]
    shopContact = params[:shopContact]
    companyshop.SHOPADD = shopAdd
    companyshop.SHOPCONTACT = shopContact
    companyshop.SHOPFAX = shopFax
    companyshop.SHOPNAME = shopName
    companyshop.SHOPTEL = shopTel
    companyshop.ADDRESS = address
    companyshop.update_attributes(params[:companyshop])
    redirect_to :action => "shop_edit",
      :id => companyshop.ID
  end
  #清缓存方法
  def delete_cache
    case_id = params[:id]
    PHOTO_CACHE.set("key_photo_show_hejia_case_#{case_id}",nil)
    PHOTO_CACHE.set("key_photo_show_photos_tag_#{case_id}",nil)
    redirect_to "/deco/case_list"
  end

  #执行查询某省市下的区县信息
  def select_city_area
    @area = get_areas2(params[:cityid])
    render :partial => "select_city_area"
  end
  #案例
  def select_city_area_1
    @area = get_areas2(params[:cityid])
    render :partial => "select_city_area_1"
  end

  #根据省市编号取得各省市下的地区域Hash
  def get_areas2(cityid)
    return {} if cityid.to_i == 0
    Tag.urban_areas_to_hash(cityid)
  end

  #取得所有省的hash
  def get_cities
    Tag.provinces_to_hash
  end

  #点评
  def dianping_list
    orderby = "id desc"
    conditions = []
    conditions << "formid = '#{$formid}' and status != '-1'"
    conditions << "c2 = #{current_user.id}"
    @reviews = DecoReview.paginate :page => params[:page], :per_page => 20,
      :conditions => conditions.join(" and "),
      :order => orderby
  end
  
  def dianping_del
    ids = params[:ids]
    DecoReply.update_all("status = '-1'", "id in ( #{ids} )")
    redirect_to :action =>'dianping_list'
  end
  #回应
  def reply_list
    conditions = []
    conditions << "formid = #{$replyid}"
    conditions << "c2 = #{current_user.id}"
    @replys = DecoReply.paginate :page => params[:page], :per_page => 20,:conditions => conditions.join(' and '),:order => "id desc"
  end
  def reply_del
    ids = params[:ids]
    DecoReply.delete_all("id in (#{ids})")
    redirect_to :action =>'reply_list'
  end

  #得到session里面的图片地址
  def getimagepath
    path = session[:backitem]
    return path
  end

  def clearsession
    session[:backitem]=nil
  end
  private
  def getint(id)
    id.to_s.to_i;
  end

  def set_image_main(case_id,photo)

    #       puts photo.filepath
    #    http://image.51hejia.com/files/hekea/case_img/20090716/tn/img200907161247728325_s.jpg
    way = truncate(photo.filepath,0,8)
    #修改的地方
    #start
    way1 = truncate(photo.filepath,32,10).length.to_i > 2 ? truncate(photo.filepath,9,23) : truncate(photo.filepath,9,21)
    if !photo.type_id.nil?&&photo.type_id.to_s=='5'
      way = photo.filepath
    else
      way = truncate(photo.filepath,32,10).length.to_i > 2 ? way+"/tn/"+way1+"_s"+truncate(photo.filepath,32,10) : way+"/tn/"+way1+"_s"+truncate(photo.filepath,30,10)
    end
    #end
    path = !photo.type_id.nil?&&photo.type_id.to_s=='5' ? "#{RAILS_ROOT}/public/"+way.to_s : "#{RAILS_ROOT}/public/files/hekea/case_img/"+way.to_s
    
    filepath = "#{RAILS_ROOT}/public/files/hekea/case_img/tn/"+case_id.to_s+".jpg" if path.include?(".jpg")
    filepath = "#{RAILS_ROOT}/public/files/hekea/case_img/tn/"+case_id.to_s+".gif" if path.include?(".gif")
    filepath = "#{RAILS_ROOT}/public/files/hekea/case_img/tn/"+case_id.to_s+".png" if path.include?(".png")
    filepath = "#{RAILS_ROOT}/public/files/hekea/case_img/tn/"+case_id.to_s+".bmp" if path.include?(".bmp")
    # 复制图片
    FileUtils.copy(path, filepath)
    # 对图片进行缩放
    Pic.case_img_resize(filepath)
  end

  private # =================  私有方法

  def find_firm
    @firm = DecoFirm.find_firm deco_company_id
  end

  def deco_company_id
    staff_logged_in? && session['deco_firm_id'] || current_deco_id
  end

end
