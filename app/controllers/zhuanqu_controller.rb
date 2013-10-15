class ZhuanquController < ApplicationController

  def zq_clear_cache(rv="",ru=nil)
    keyword = trim(params[:keyword])
    if keyword.length > 0
      kws = ["gabek_#{keyword}1","gabek_#{keyword}2","zq_#{keyword}_rc"]
      for kw in kws
        TAG_CACHE.set(kw, nil)
      end
      rv = "操作成功：缓存已清除！"
    else
      rv = "操作失败：参数错误！"
    end
    myrender(rv,ru)
  end

  def fuheci
    @sort_id1 = params[:sort_id1].to_i
    @sort_id2 = params[:sort_id2].to_i
    @sort_id1 = 4348 if @sort_id1 ==0
    @sort_id2 = 4348 if @sort_id2 ==0
    @cws = paging_record options = {
      "model" => ZhuanquCw,
      "pagesize" => 100,   #每页记录数
      "listsize" => 10,  #同时显示的页码数
      "select" => "id,tagname,kw1,kw2,sort_id1,sort_id2,is_confirmed,case_num,created_at,updated_at",
      "conditions" => "sort_id1 = #{@sort_id1} and sort_id2 = #{@sort_id2}",
      "order" => "id desc"
    }
    
  end

  def fuheci_rename(rv="",ru=nil)
    newname = trim(params[:newname])
    tag_id = params[:tag_id].to_i
    if newname.length==0 || tag_id==0
      rv = "操作失败：参数不足！"
    else
      begin
        ZhuanquCw.update(tag_id, "tagname"=> newname)
      rescue Exception => e
        rv = "操作失败：#{get_error(e)}"
      end
    end
    myrender(rv,ru)
  end

  def yuanci_replace(rv="",ru=nil)
    oldtagname = trim(params[:oldtagname])
    newtagname = trim(params[:newtagname])
    if oldtagname.length == 0 || newtagname.length == 0
      rv = "旧原词和新原词都必须填写！"
    else
      begin
        ZhuanquCw.update_all("kw1 = '#{newtagname}'", "kw1 = '#{oldtagname}'")
        ZhuanquCw.update_all("kw2 = '#{newtagname}'", "kw2 = '#{oldtagname}'")
        ru = "reload"
      rescue Exception => e
        rv = "操作失败：#{get_error(e)}"
      end
    end
    myrender(rv,ru)
  end

  def fuheci_generate(rv="",ru=nil)
    @sort_id1 = params[:sort_id1].to_i
    @sort_id2 = params[:sort_id2].to_i
    if @sort_id1 == 0 || @sort_id2 == 0
      rv = "操作错误：请选择分类一和分类二！"
    elsif !ZhuanquCw.find(:first,:select=>"id",:conditions=>"(sort_id1 = #{@sort_id1} and sort_id2 = #{@sort_id2}) or (sort_id1 = #{@sort_id2} and sort_id2 = #{@sort_id1})").nil?
      rv = "操作错误：这两种分类的复合词已经存在，无法再次生成！"
      ru = "self"
    else
      for tag1 in get_case_tags_by_fahtertagid(@sort_id1)
        for tag2 in get_case_tags_by_fahtertagid(@sort_id2)
          if (!is_reject_tag(tag1.TAGNAME)) && (!is_reject_tag(tag2.TAGNAME)) #如果都不是要排除的词
            ZhuanquCw.create(:tagname=>"#{tag1.TAGNAME}#{tag2.TAGNAME}", :kw1=>tag1.TAGNAME, :kw2=>tag2.TAGNAME, :sort_id1=>@sort_id1, :sort_id2=>@sort_id2)
          end
        end
      end
      rv = "操作成功: 相关分类复合词已生成！"
      ru = "/zhuanqu/fuheci?sort_id1=#{@sort_id1}&sort_id2=#{@sort_id2}"
    end
    myrender(rv,ru)
  end
  
  def is_reject_tag(name)
    @reject_wildcards = ["其它","其他","家有","|"] if @reject_wildcards.nil?
    @reject_words = ["原创赏析","编辑推荐","本地图库","生活方式","桌面壁纸","重软装"] if @reject_words.nil?
    for kw in @reject_wildcards
      return true if name.include?(kw)
    end
    if @reject_words.include?(name)
      return true
    else
      return false
    end
  end

  def fuheci_del(rv="",ru=nil)
    ids = trim(params[:ids].to_s)
    if ids.length > 0
      begin
        ZhuanquCw.delete_all("id in (#{ids})")
        ru = "reload"
      rescue Exception => e
        rv = "操作失败：#{get_error(e)}"
      end
    else
      rv = "请至少选择一条记录！"
    end
    myrender(rv,ru)
  end

  def stat_case(rv="",ru=nil) #统计案例
    ids = trim(params[:ids].to_s).split(",")
    if ids.length > 0
      begin
        for id in ids
          if (id = id.to_i) > 0
            cw = ZhuanquCw.find(id,:select=>"kw1,kw2")
            case_num = get_case_num(cw.kw1, cw.kw2)
            ZhuanquCw.update_all("case_num = #{case_num}", "id = #{id}")
          end
        end
        ru = "reload"
      rescue Exception => e
        rv = "操作失败：#{get_error(e)}"
      end
    end
    myrender(rv,ru)
  end
  
  def fuheci_rec(rv="",ru=nil)
    ids = trim(params[:ids].to_s)
    if ids.length > 0
      begin
        ZhuanquCw.update_all("is_confirmed = 1", "id in (#{ids})")
        ru = "reload"
      rescue Exception => e
        rv = "操作失败：#{get_error(e)}"
      end
    else
      rv = "请至少选择一条记录！"
    end
    myrender(rv,ru)
  end

  def fuheci_can(rv="",ru=nil)
    ids = trim(params[:ids].to_s)
    if ids.length > 0
      begin
        ZhuanquCw.update_all("is_confirmed = 0", "id in (#{ids})")
        ru = "reload"
      rescue Exception => e
        rv = "操作失败：#{get_error(e)}"
      end
    else
      rv = "请至少选择一条记录！"
    end
    myrender(rv,ru)
  end


  def get_case_tags_by_fahtertagid(fahtertagid)
    tags = Tag.find(:all,:select=>"TAGID, TAGNAME",:conditions=>"TAGFATHERID = #{fahtertagid} and TAGESTATE='0' and TAGTYPE = 'case'")
    return tags
  end

  def get_case_id(kw)
    conditions = []
    conditions << "TAGESTATE='0' and TAGTYPE='case'"
    conditions << "TAGNAME='#{kw}'"
    tag_id = Tag.find(:first,:select=>"TAGID",:conditions=>conditions.join(" and ")).TAGID rescue 0
    return tag_id
  end

  def get_case_num(kw1, kw2)
    case_ids = []
    tag_id2 = get_case_id(kw2)
    conditions = []
    conditions << "l.ENTITYID = c.ID and l.LINKTYPE='case' and c.STATUS <> '-100'"
    conditions << "l.TAGID = #{tag_id2}"
    case_ids = HejiaCase.find(:all,:select=>"c.ID",:joins=>"c, HEJIA_TAG_ENTITY_LINK l",:conditions=>conditions.join(" and ")).collect{|r| r.ID.to_i}

    tag_id1 = get_case_id(kw1)
    conditions = []
    conditions << "l.ENTITYID = c.ID and l.LINKTYPE='case' and c.STATUS<>'-100' and l.STATUS<>-1"
    conditions << "l.TAGID = #{tag_id1}"
    conditions << "c.ID in (#{case_ids.join(",")})" if case_ids.length > 0

    return HejiaCase.count("c.ID", :joins => "c, HEJIA_TAG_ENTITY_LINK l", :conditions => conditions.join(" and "))
  end

  def kw_list
    return false unless pvalidate("浏览专区分类列表","管理员","文章编辑")
    @sort_id = params[:sort_id].to_i
    @kw_name = trim(params[:kw_name])
    conditions = []
    conditions << "is_delete = 0"
    conditions << "kw_name like '%#{@kw_name}%'" if @kw_name.length > 0
    conditions << "sort_id = #{@sort_id}" if @sort_id > 0
    @kws = paging_record options = {
      "model" => ZhuanquKw,
      "pagesize" => 15,   #每页记录数
      "listsize" => 10,  #同时显示的页码数
      "select" => "id,sort_id,kw_name,is_published,created_at",
      "conditions" => conditions.join(" and "),
      "order" => "id desc"
    }
  end

  def kw_edit
    return false unless pvalidate("编辑专区关键词内容","管理员","文章编辑")
    @id = params[:id].to_i
    if @id == 0
      @zq = ZhuanquKw.new
    else
      @zq = ZhuanquKw.find(@id)  #这里确实需要使用到select *
    end
  end

  def get_zhuanqu_images  #保存上传的专区相关图片并取得路径
    imgs = ["hot1_image_url2","hot2_image_url2","zt_image_url1","zt_image_url2","zt_image_url3","zt_image_url4"]
    for img in imgs
      filename = get_file(params[img], "/uploads/zhuanqu/")
      @zq[img] = "http://#{request.env["HTTP_HOST"]}/uploads/zhuanqu/#{filename}" unless filename.nil?
    end
  end

  def get_zhuanqu_sort_images  #保存上传的分类专区相关图片并取得路径
    imgs = ["tuijian_image_url1","tuijian_image_url2","tuijian_image_url3","tuijian_image_url4","jiaodiantu_image_url1","jiaodiantu_image_url2","jiaodiantu_image_url3","kw_image_url1","kw_image_url2","kw_image_url3","kw_image_url4","zt_image_url2","zt_image_url3","pp_image_url2","pp_image_url3"]
    for img in imgs
      filename = get_file(params[img], "/uploads/zhuanqu/")
      @zq[img] = "http://#{request.env["HTTP_HOST"]}/uploads/zhuanqu/#{filename}" unless filename.nil?
    end
  end

  def get_dianxing_images  #保存上传的典型频道相关图片并取得路径
    imgs = ["tuijian_image_url1", "tuijian_image_url2", "tuijian_image_url3", "tuijian_image_url4", "tuijian_image_url5", "tuijian_image_url9", "jiaodiantu_image_url1", "jiaodiantu_image_url2", "jiaodiantu_image_url3", "jiaodiantu_image_url4", "jiaodiantu_image_url5", "lm1_image_url1", "lm1_image_url2", "lm1_image_url3", "lm1_image_url4", "lm1_image_url5", "lm2_image_url1", "lm2_image_url2", "lm2_image_url3", "lm2_image_url4", "lm3_image_url1", "lm3_image_url2", "lm3_image_url3", "lm3_image_url4", "lm3_image_url5", "lm4_image_url1", "lm4_image_url2", "lm4_image_url3", "lm5_image_url1", "lm5_image_url2", "lm5_image_url3", "tg1_image_url", "tg2_image_url"]
    get_set_images(imgs,"zhuanqu",@dx)
    #     for img in imgs
    #      filename = get_file(params[img], "/uploads/zhuanqu/")
    #      @dx[img] = "http://#{request.env["HTTP_HOST"]}/uploads/zhuanqu/#{filename}" unless filename.nil?
    #    end
  end

  def kw_edit_save(rv="",ru=nil)
    return false unless pvalidate("保存专区关键词内容","管理员","文章编辑")
    id = params[:id].to_i
    @zq = params[:zq]
    if @zq.length == 0
      rv = "参数不足！"
    else
      begin
        get_zhuanqu_images  #保存上传的专区相关图片并取得路径
        if id == 0 #创建新记录
          zq = ZhuanquKw.create(@zq)
          rv = "新记录创建成功！"
          ru = "/zhuanqu/kw_edit?id=#{zq.id}"
        else
          zq = ZhuanquKw.find(id)
          zq.update_attributes(@zq)
          rv = "修改信息已保存！"
          ru = "reload"
        end
        ckw = "zhuanqu_info_#{trim(@zq["kw_name"])}"
        PUBLISH_CACHE.set(ckw, nil)
      rescue Exception => e
        if e.to_s.include?("Duplicate entry")
          rv = "已存在相同的关键词！"
        else
          rv = get_error(e)
        end
      end
    end
    myrender(rv,ru)
  end

  
  
  def dantu_list #单图专区列表
    return false unless pvalidate("浏览单图专区列表","管理员","文章编辑")
    @name = trim(params[:name])
    @sort_id = params[:sort_id].to_i
    conditions = []
    conditions << "is_delete = 0"
    conditions << "name like '%#{@name}%'" if @name.length > 0
    conditions << "sort_id = #{@sort_id}" if @sort_id > 0
    @dantus = paging_record options = {
      "model" => ZhuanquDantu,
      "pagesize" => 15,   #每页记录数
      "listsize" => 10,  #同时显示的页码数
      "select" => "id,name,sort_id,split,description,is_published,created_at",
      "conditions" => conditions.join(" and "),
      "order" => "id desc"
    }
  end

  def dantu_edit  #单图专区编辑
    return false unless pvalidate("编辑单图专区内容","管理员","文章编辑")
    @id = params[:id].to_i
    if @id == 0
      @zq = ZhuanquDantu.new
    else
      @zq = ZhuanquDantu.find(@id)  #这里确实需要使用到select *
    end
  end

  def dantu_edit_save
    return false unless pvalidate("保存单图专区内容","管理员","文章编辑")
    id = params[:id].to_i
    @zq = params[:zq]
    if @zq.length == 0
      @rv = "参数不足！"
    else
      begin
        if id == 0 #创建新记录
          zq = ZhuanquDantu.create(@zq)
          @rv = "新记录创建成功！"
          @ru = "/zhuanqu/dantu_edit?id=#{zq.id}"
        else
          zq = ZhuanquDantu.find(id)
          zq.update_attributes(@zq)
          @rv = "修改信息已保存！"
        end
      rescue Exception => e
        if e.to_s.include?("Duplicate entry")
          @rv = "保存失败：已存在相同的关键词！"
        else
          @rv = get_error(e)
        end
      end
    end
    myrender(@rv,@ru)
  end

  def dantu_del
    return false unless pvalidate("删除单图专区","管理员","文章编辑")
    ids = trim(params[:ids].to_s)
    if ids.length > 0
      begin
        ZhuanquDantu.update_all("is_delete = 1", "id in (#{ids})")
      rescue Exception => e
        @rv = "操作失败：#{get_error(e)}"
      end
    else
      @rv = "请至少选择一条记录！"
    end
    myrender(@rv,@ru)
  end
 

  def kw_del
    return false unless pvalidate("删除专区关键词","管理员","文章编辑")
    ids = trim(params[:ids].to_s)
    if ids.length > 0
      begin
        ZhuanquKw.update_all("is_delete = 1", "id in (#{ids})")
      rescue Exception => e
        @rv = "操作失败：#{get_error(e)}"
      end
    else
      @rv = "请至少选择一条记录！"
    end
    myrender(@rv, @ru)
  end
  
  def zq_publish
    return false unless pvalidate("发布栏目专区","管理员","文章编辑")
    id = params[:id].to_i
    zq_type = params[:zq_type].to_s
    @rv = "参数错误!" if id == 0
    if @rv.nil?
      begin
        case zq_type
        when "sort"
          ZhuanquSort.update_all("is_published = abs(is_published-1)", ["id = ?", id])
        when "kw"
          ZhuanquKw.update_all("is_published = abs(is_published-1)", ["id = ?", id])
        when "dantu"
          ZhuanquDantu.update_all("is_published = abs(is_published-1)", ["id = ?", id])
        end
        @ru = "reload"
      rescue Exception => e
        @rv = "操作失败：#{get_error(e)}"
      end
    end
    myrender(@rv.to_s,@ru)
  end

  #典型频道
 def dianxing_list
    return false unless pvalidate("浏览典型频道列表","管理员","文章编辑")
    @name = trim(params[:name])
    conditions = []
    conditions << "is_delete = 0"
    conditions << "name like '%#{@name}%'" if @name.length > 0
    @rs = paging_record options = {
      "model" => Dianxing,
      "pagesize" => 15,   #每页记录数
      "listsize" => 10,  #同时显示的页码数
      "select" => "id,name,spell,created_at",
      "conditions" => conditions.join(" and "),
      "order" => "id desc"
    }
  end

  def dianxing_edit
    return false unless pvalidate("编辑典型频道内容","管理员","文章编辑")
    @id = params[:id].to_i
    if @id == 0
      @dx = Dianxing.new
    else
      @dx = Dianxing.find(@id)  #这里确实需要使用到select *
    end
  end

  def dianxing_edit_save
    return false unless pvalidate("保存专区分类","管理员","文章编辑")
    id = params[:id].to_i
    @dx = params[:dx]
    @dx["jiaodiantu_order"] = trim(@dx["jiaodiantu_order"]).gsub("  ", " ")
    if @dx.length == 0
      @rv = "参数不足！"
    else
      begin
        get_dianxing_images  #保存上传的典型频道相关图片并取得路径
        if id == 0 #创建新记录
          dx = Dianxing.new
          dx.save
          Dianxing.updates(@dx, dx.id)
          @rv = "新记录创建成功！"
          @ru = "/zhuanqu/dianxing_edit?id=#{dx.id}"
        else
          Dianxing.updates(@dx, id)
          @rv = "修改信息已保存！"
          @ru = "reload"
        end
      rescue Exception => e
        if e.to_s.include?("Duplicate entry")
          @rv = "保存失败：已存在同名的频道！"
        else
          @rv = get_error(e)
        end
      end
    end
    myrender(@rv,@ru)
  end

  def dianxing_del
    return false unless pvalidate("删除典型频道记录","管理员","文章编辑")
    ids = trim(params[:ids].to_s)
    if ids.length > 0
      begin
        Dianxing.update_all("is_delete = 1", "id in (#{ids})")
      rescue Exception => e
        @rv = "操作失败：#{get_error(e)}"
      end
    else
      @rv = "请至少选择一条记录！"
    end
    myrender(@rv, @ru)
  end

 #品类频道
  def pinlei_list
    return false unless pvalidate("浏览品类频道列表","管理员","文章编辑")
    @name = trim(params[:name])
    conditions = []
    conditions << "is_delete = 0"
    conditions << "name like '%#{@name}%'" if @name.length > 0
    @rs = paging_record options = {
      "model" => PinleiPindao,
      "pagesize" => 15,   #每页记录数
      "listsize" => 10,  #同时显示的页码数
      "select" => "id,name,spell,created_at",
      "conditions" => conditions.join(" and "),
      "order" => "id desc"
    }
  end

  def pinlei_edit
    return false unless pvalidate("编辑品类频道内容","管理员","文章编辑")
    @id = params[:id].to_i
    if @id == 0
      @pl = PinleiPindao.new
    else
      @pl = PinleiPindao.find(@id)  #这里确实需要使用到select *
    end
  end
  
  def pinlei_edit_save
    return false unless pvalidate("保存专区分类","管理员","文章编辑")
    id = params[:id].to_i
    @pl = params[:pl]
    @pl["jiaodiantu_order"] = trim(@pl["jiaodiantu_order"]).gsub("  ", " ")
    if @pl.length == 0
      @rv = "参数不足！"
    else
      begin
        get_set_images([
            "jiaodiantu_image_url1" , "jiaodiantu_image_url2" ,     "jiaodiantu_image_url3" , "jiaodiantu_image_url4" ,
            "jiaodiantu_image_url5" ,     "tw_image_url1" ,            "tw_image_url5" ,           "tj_image_url1" ,
            "tj_image_url2" ,            "tj_image_url3" ,            "tj_image_url4" ,            "lm1_image_url1" ,
            "lm1_image_url2" ,             "lm1_image_url3" ,              "lm1_image_url4" ,             "lm1_image_url5" ,
            "lm2_image_url1" ,             "lm2_image_url2" ,              "lm2_image_url3" ,             "lm2_image_url4" ,
            "lm2_image_url5" ,             "lm3_image_url1" ,             "lm3_image_url2" ,             "lm3_image_url3" ,
            "lm3_image_url4" ,             "lm3_image_url5" ,              "lm4_image_url1" ,              "lm4_image_url2" ,
            "lm4_image_url3" ,             "lm4_image_url4" ,               "lm4_image_url5" ,             "lm5_image_url1" ,
            "lm5_image_url2" ,             "lm5_image_url3" ,             "lm5_image_url4" ,             "lm5_image_url5" ,
            "pp_image_url11" ],"zhuanqu" , @pl)
        if id == 0 #创建新记录
          pl = PinleiPindao.new
          pl.save
          PinleiPindao.updates(@pl, pl.id)
          @rv = "新记录创建成功！"
          @ru = "/zhuanqu/pinlei_edit?id=#{pl.id}"
        else
          PinleiPindao.updates(@pl, id)
          @rv = "修改信息已保存！"
        end
      rescue Exception => e
        if e.to_s.include?("Duplicate entry")
          @rv = "保存失败：已存在同名的频道！"
        else
          @rv = get_error(e)
        end
      end
    end
    myrender(@rv,@ru)
  end

  def pinlei_del
    return false unless pvalidate("删除品类频道记录","管理员","文章编辑")
    ids = trim(params[:ids].to_s)
    if ids.length > 0
      begin
        PinleiPindao.update_all("is_delete = 1", "id in (#{ids})")
      rescue Exception => e
        @rv = "操作失败：#{get_error(e)}"
      end
    else
      @rv = "请至少选择一条记录！"
    end
    myrender(@rv, @ru)
  end

  #栏目专区
  def sort_list
    return false unless pvalidate("浏览专区分类列表","管理员","文章编辑")
    @board_id = params[:board_id].to_i
    @sort_name = trim(params[:sort_name])
    conditions = []
    conditions << "is_delete = 0"
    conditions << "sort_name like '%#{@sort_name}%'" if @sort_name.length > 0
    conditions << "board_id = #{@board_id}" if @board_id > 0
    @sorts = paging_record options = {
      "model" => ZhuanquSort,
      "pagesize" => 15,   #每页记录数
      "listsize" => 10,  #同时显示的页码数
      "select" => "id,sort_name,is_published,board_id,created_at",
      "conditions" => conditions.join(" and "),
      "order" => "id desc"
    }
  end

  def sort_edit
    return false unless pvalidate("编辑专区分类内容","管理员","文章编辑")
    @id = params[:id].to_i
    if @id == 0
      @zq = ZhuanquSort.new
    else
      @zq = ZhuanquSort.find(@id)  #这里确实需要使用到select *
    end
  end

  def sort_edit_save(rv="",ru=nil)
    return false unless pvalidate("保存专区分类","管理员","文章编辑")
    id = params[:id].to_i
    @zq = params[:zq]
    if @zq.length == 0
      rv = "参数不足！"
    else
      begin
        get_zhuanqu_sort_images  #保存上传的分类专区相关图片并取得路径
        if id == 0 #创建新记录
          @zq[:sub_kws]=ZhuanquSort.get_sub_kws_by_sort_name(@zq[:sort_name])
          zq = ZhuanquSort.create(@zq)
          rv = "新记录创建成功！"
          ru = "/zhuanqu/sort_edit?id=#{zq.id}"
        else
          zq = ZhuanquSort.find(id)
          if(@zq[:sub_kws].nil?||@zq[:sub_kws]=="")
            @zq[:sub_kws]=ZhuanquSort.get_sub_kws_by_sort_name(@zq[:sort_name])
          else
            @zq[:sub_kws]=@zq[:sub_kws].gsub(","," ").gsub(";"," ").gsub("，"," ").gsub("；"," ").gsub("  "," ")
          end
          zq.update_attributes(@zq)
          rv = "修改信息已保存！"
          ru = "reload"
        end
        #        ckw = "zhuanqu_info_#{trim(@zq["kw_name"])}"
        #        PUBLISH_CACHE.set(ckw, nil)
      rescue Exception => e
        if e.to_s.include?("Duplicate entry")
          rv = "保存失败：已存在同名的分类专区！"
        else
          rv = get_error(e)
        end
      end
    end
    myrender(rv,ru)
  end

  def sort_del
    return false unless pvalidate("删除专区分类","管理员","文章编辑")
    ids = trim(params[:ids].to_s)
    if ids.length > 0
      begin
        ZhuanquSort.update_all("is_delete = 1", "id in (#{ids})")
      rescue Exception => e
        @rv = "操作失败：#{get_error(e)}"
      end
    else
      @rv = "请至少选择一条记录！"
    end
    myrender(@rv, @ru)
  end

  def sort_fresh
    return false unless pvalidate("刷新专区分类","管理员","文章编辑")
    begin
      ZhuanquSort.fresh_sub_kws()
      @rv = "操作成功：下级关键词已全部填充！"
    rescue Exception => e
      @rv = "填充失败：#{get_error(e)}"
    end
    myrender(@rv, @ru)
  end
  
  #行业栏目
  def hangye_list
    return false unless pvalidate("浏览行业栏目列表","管理员","文章编辑")
    @name = trim(params[:name])
    conditions = []
    conditions << "is_delete = 0"
    conditions << "name like '%#{@name}%'" if @name.length > 0
    @rs = paging_record options = {
      "model" => ZhuanquHangye,
      "pagesize" => 15,   #每页记录数
      "listsize" => 10,  #同时显示的页码数
      "select" => "id,name,created_at",
      "conditions" => conditions.join(" and "),
      "order" => "id desc"
    }
  end

  def hangye_edit
    return false unless pvalidate("编辑行业栏目内容","管理员","文章编辑")
    @id = params[:id].to_i
    if @id == 0
      @hy = ZhuanquHangye.new
    else
      @hy = ZhuanquHangye.find(@id)  #这里确实需要使用到select *
    end
  end

  def hangye_edit_save
    return false unless pvalidate("保存专区分类","管理员","文章编辑")
    id = params[:id].to_i
    @hy = params[:hy]
    if @hy.length == 0
      @rv = "参数不足！"
    else
      begin
        get_set_images(["big_image_url"],"zhuanqu" , @hy)
        if id == 0 #创建新记录
          hy = ZhuanquHangye.new
          hy.save
          ZhuanquHangye.updates(@hy, hy.id)
          sort=ZhuanquSort.new(:sort_name=>@hy[:name],:board_id=>4)
          sort.save
          @rv = "新记录创建成功！"
          @ru = "/zhuanqu/hangye_edit?id=#{hy.id}"
        else
          ZhuanquHangye.updates(@hy, id)
          @rv = "修改信息已保存！"
          @ru = "reload"
        end
      rescue Exception => e
        if e.to_s.include?("Duplicate entry")
          @rv = "保存失败：已存在同名的行业栏目！"
        else
          @rv = get_error(e)
        end
      end
    end
    myrender(@rv,@ru)
  end
  
  def hangye_del
    return false unless pvalidate("删除行业栏目记录","管理员","文章编辑")
    ids = trim(params[:ids].to_s)
    if ids.length > 0
      begin
        ZhuanquHangye.update_all("is_delete = 1", "id in (#{ids})")
      rescue Exception => e
        @rv = "操作失败：#{get_error(e)}"
      end
    else
      @rv = "请至少选择一条记录！"
    end
    myrender(@rv, @ru)
  end


  def memcache
    
  end
  
  private

  def get_set_images(imgs,area,val)
    for img in imgs
      filename = get_file(params[img], "/uploads/#{area}/")
      val[img] = "http://#{request.env["HTTP_HOST"]}/uploads/#{area}/#{filename}" unless filename.nil?
    end
  end
end
