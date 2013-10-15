module AdminCaseHelper
  def get_tag_father_tagname(tid,tname)
  fname=""
  if !tid.nil? && tname=="qita"
    tagsql = "select TAGNAME from HEJIA_TAG where TAGID=(select TAGFATHERID from HEJIA_TAG where TAGID=#{tid})"
    qitatag=HejiaTag.find_by_sql tagsql
    if !qitatag.nil? && !qitatag[0].TAGNAME.nil?
      fname="<span>"+qitatag[0].TAGNAME+"</span>"
    end
  end
  return fname
end
def query_small_image(id, type_id, mphoto)
    if type_id == 5 || type_id == -5
      image_url = "http://image.51hejia.com#{mphoto}"
    else
      image_url = "http://image.51hejia.com/files/hekea/case_img/tn/#{id}.jpg"
    end
    return image_url
  end
  def is_fav(id, ids)
    if ids.nil?
      fav_info = ["收藏","save"]
    else
      if ids.split(",").include?(id.to_s)
        fav_info = ["取消","delete"]
      else
        fav_info = ["收藏","save"]
      end
    end
    return fav_info
  end
  def query_case_tags(case_id)
    sql = "select t.tagid as tid,t.tagname as tname,t.tagurl as turl,t1.tagid as tfid,t1.tagname as tfname,t1.tagurl as tfurl" +
      " from HEJIA_TAG_ENTITY_LINK l,HEJIA_TAG t,HEJIA_TAG t1 where l.linktype='case' and l.entityid=#{case_id}" +
      " and l.tagid=t.tagid and t.tagfatherid<>4401 and t1.TAGID = t.TAGFATHERID and t.TAGFATHERID != 31262 and t.TAGFATHERID != 4350"
    results = HejiaTag.find_by_sql(sql)
    return results
  end
  def query_designers_by_company_id(id)
    return HejiaDesignerModel.find(:all,
      :conditions => ["COMPANY = ? and STATUS != ?", id, -100])
  end

  def query_company_cn_name_by_company_id(id)
    result = HejiaCompany.find(:first,
      :conditions => ["ID = ? and STATUS != ?", id, -100])
    return result.CN_NAME if result
  end

  def query_case_num_by_designer_id(id)
    sql = "select count(id) from HEJIA_CASE where DESIGNERID = #{id} and STATUS != -100;"
    result = HejiaCase.count_by_sql(sql)
    return result if result
  end

  def query_designer_name_by_id(id)
    result = HejiaDesignerModel.find(:first,
      :conditions => ["ID = ? and STATUS != ?", id, -100])
    return result.DESNAME if result
  end

  def query_case_pic_num(id)
    pic_num = PhotoPhoto.count "case_id = #{id}"
    return pic_num
  end
  
  def query_cases_pic_num(ids)
    unless ids.empty?
      pic_num = PhotoPhoto.count "case_id in (#{ids.join(",")})"
    else
      pic_num = 0
    end
    return pic_num
  end

  def query_tag(id)
    Tag.find(:first, :conditions => "TAGID = #{id}")
  end

  def query_small_image_url(id, main_photo)
    if main_photo
      image_url = "http://d.51hejia.com/files/hekea/case_img/small/#{main_photo}"
      return image_url
    else
      photo = PhotoPhoto.find(:first, :conditions => ["case_id = ?", id])
      if photo
        image_url = "http://d.51hejia.com/files/hekea/case_img/small/#{photo.filepath}"
        return image_url
      else
        image_url = "http://d.51hejia.com/api/images/none.gif"
        return image_url
      end
    end
  end

  def get_case_tags(id)
    tls = HejiaTagEntityLink.find(:all, :conditions => ["ENTITYID = ?", id])
    tags = []
    tls.each do |tl|
      name = Tag.find(:first, :conditions => ["TAGID = ?", tl.TAGID]).TAGNAME
      tags << name
    end
    return tags.join(",")
  end

  def is_checked(tags, id)
    tagids = []
    tags.each{|x|tagids << x.TAGID}
    tagids.uniq
    if tagids.include?(id)
      return "checked"
    end
  end

  def is_checked_pic(tagids, id)
    name = Tag.find(:first, :conditions => ["TAGID = ?", id])
    if tagids.include?(name.TAGNAME)
      return "checked"
    end
  end

  def count_case_pic_tags(id)
    case_tag_num = HejiaTagEntityLink.count "ENTITYID = #{id} and LINKTYPE = 'case'"
    photos = PhotoPhoto.find(:all, :select => "id", :conditions => "case_id = #{id}")
    unless photos.empty?
      ids = []
      photos.map { |p| ids << p.id }
      pic_tag_num = PhotoPhotosTag.count "photo_id in (#{ids.join(",")})"
    end
    return "套图标签：<strong>#{case_tag_num}</strong>，图片标签：<strong>#{pic_tag_num}</strong>"
  end

  # type(case,editor)
  # state(1,2,3,4,5)
  def check_state(option={})
    case option[:state]
    when "1"
      if option[:type] == "case"
        return "<span style='background-color:#ffa0a0;'>未分配</span>"
      end
      if option[:type] == "editor"
        return "<span style='background-color:#ffd850;'>未打标签</span>"
      end
    when "2"
      if option[:type] == "case"
        return "<span style='background-color:#ffd850;'>已分配</span>"
      end
      if option[:type] == "editor"
        return "<span style='background-color:#c8c8ff;'>已打标签未审核</span>"
      end
    when "3"
      if option[:type] == "case"
        return "<span style='background-color:#c8c8ff;'>已打标签未审核</span>"
      end
      if option[:type] == "editor"
        return "<span style='background-color:#ff50a8;'>未通过审核</span>"
      end
    when "4"
      if option[:type] == "case"
        return "<span style='background-color:#ff50a8;'>未通过审核</span>"
      end
      if option[:type] == "editor"
        return "<span style='background-color:#cceedd;'>审核已通过</span>"
      end
    when "5"
      if option[:type] == "case"
        return "<span style='background-color:#cceedd;'>审核已通过</span>"
      end
    end
  end

  def pic_tags(t)
    children = Tag.find(:all, :conditions => "TAGFATHERID = #{t.TAGID} and TAGESTATE != -1")
    conditions = []
    children.each do |c|
      conditions << "name = '#{c.TAGNAME}'"
    end
    ppts = PhotoTag.find(:all, :conditions => conditions.join(" or "))
    ppts
  end

  def return_tfurl_turl(tfname, tname, tfu, tu)
    if tfname == "费用"
      if tname == "5万以下"
        turl = "5"
      elsif tname == "5－8万"
        turl = "5_8"
      elsif tname == "8－12万"
        turl = "8_12"
      elsif tname == "12－20万"
        turl = "12_20"
      elsif tname == "20－30万"
        turl = "20_30"
      elsif tname == "30万以上"
        turl = "30"
      elsif tname == "经济型"
        turl = "jingji"
      elsif tname == "富裕型"
        turl = "fuyu"
      elsif tname == "豪华型"
        turl = "haohua"
      end
      tfurl = "feiyong"
    elsif tfname == "风格"
      if tname == "现代简约"
        turl = "xiandaijianyue"
      elsif tname == "中式风格"
        turl = "zhongshi"
      elsif tname == "欧/美式"
        turl = "oumei"
      elsif tname == "混搭"
        turl = "hunda"
      elsif tname == "地中海"
        turl = "dizhonghai"
      elsif tname == "田园风格"
        turl = "tianyuan"
      elsif tname == "其他"
        turl = "qita"
      end
      tfurl = "fengge"
    elsif tfname == "装修用途"
      if tname == "旧房改造"
        turl = "jiufang"
      elsif tname == "婚房装修"
        turl = "hunfang"
      elsif tname == "单身贵族"
        turl = "danshen"
      elsif tname == "三口之家"
        turl = "sankou"
      elsif tname == "家有老人"
        turl = "laoren"
      elsif tname == "设计师的家"
        turl = "shejishi"
      elsif tname == "出租房"
        turl = "chuzufang"
      elsif tname == "重软装"
        turl = "zhongruanfang"
      elsif tname == "家有宠物"
        turl = "chongwu"
      elsif tname == "家有儿童"
        turl = "ertong"
      elsif tname == "其他"
        turl = "qita"
      end
      tfurl = "yongtu"
    elsif tfname == "户型"
      if tname == "小户型装修"
        turl = "xiaohu"
      elsif tname == "公寓装修"
        turl = "gongyu"
      elsif tname == "别墅/复式"
        turl = "bieshu"
      end
      tfurl = "huxing"
    else
      tfurl = tfu
      turl = tu
    end
    if tfurl.nil?
      tfurl = tfu
    end
    if turl.nil?
      turl = tu
    end
    return [tfurl, turl]
  end
  #调用已经生成列表页的五个相关标签(老的)
  def return_old_tfurl_turl(tfname, tname, tfu, tu)
    if tfname == "费用"
      if tname == "5万以下"
        turl = "5"
      elsif tname == "5－8万"
        turl = "5_8"
      elsif tname == "8－12万"
        turl = "8_12"
      elsif tname == "12－20万"
        turl = "12_20"
      elsif tname == "20－30万"
        turl = "20_30"
      elsif tname == "30万以上"
        turl = "30"
      elsif tname == "经济型"
        turl = "jingji"
      elsif tname == "富裕型"
        turl = "fuyu"
      elsif tname == "豪华型"
        turl = "haohua"
      end
      tfurl = "feiyong"
    elsif tfname == "风格"
      if tname == "现代简约"
        turl = "xiandaijianyue"
      elsif tname == "中式风格"
        turl = "zhongshi"
      elsif tname == "欧/美式"
        turl = "oumei"
      elsif tname == "混搭"
        turl = "hunda"
      elsif tname == "地中海"
        turl = "dizhonghai"
      elsif tname == "田园风格"
        turl = "tianyuan"
      elsif tname == "其他"
        turl = "qita"
      end
      tfurl = "fengge"
    elsif tfname == "装修用途"
      if tname == "旧房改造"
        turl = "jiufang"
      elsif tname == "婚房装修"
        turl = "hunfang"
      elsif tname == "单身贵族"
        turl = "danshen"
      elsif tname == "三口之家"
        turl = "sankou"
      elsif tname == "家有老人"
        turl = "laoren"
      elsif tname == "设计师的家"
        turl = "shejishi"
      elsif tname == "出租房"
        turl = "chuzufang"
      elsif tname == "重软装"
        turl = "zhongruanfang"
      elsif tname == "家有宠物"
        turl = "chongwu"
      elsif tname == "家有儿童"
        turl = "ertong"
      elsif tname == "其他"
        turl = "qita"
      end
      tfurl = "yongtu"
    elsif tfname == "户型"
      if tname == "小户型装修"
        turl = "xiaohu"
      elsif tname == "公寓装修"
        turl = "gongyu"
      elsif tname == "别墅/复式"
        turl = "bieshu"
      end
      tfurl = "huxing"
    elsif tfname == "颜色"
      if tname == "白色"
        turl = "baise"
      elsif tname == "蓝色"
        turl = "lanse"
      elsif tname == "灰色"
        turl = "huise"
      elsif tname == "棕色"
        turl = "zongse"
      elsif tname == "紫色"
        turl = "zise"
      elsif tname == "绿色"
        turl = "lvse"
      elsif tname == "黄色"
        turl = "huangse"
      elsif tname == "红色"
        turl = "hongse"
      elsif tname == "橙色"
        turl = "chengse"
      elsif tname == "粉色"
        turl = "fense"
      elsif tname == "黑色"
        turl = "heise"
      end
      tfurl = "yanse"
    elsif tfname == "特别选项"
      if tname == "编辑推荐"
        turl = "bianjituijian"
      elsif tname == "解决方案"
        turl = "jiejuefangan"
      elsif tname == "海外人家"
        turl = "haiwairenjia"
      elsif tname == "本地图库"
        turl = "bendituku"
      elsif tname == "生活方式"
        turl = "shenghuofangshi"
      elsif tname == "生活方式"
        turl = "shenghuofangshi"
      elsif tname == "原创赏析"
        turl = "yuanchuangshangxi"
      elsif tname == "桌面壁纸"
        turl = "zhuomianbizhi"
      end
      tfurl = "tebiexuanxiang"
    elsif tfname == "装修方式"
      if tname == "清包装修"
        turl = "qingbao"
      elsif tname == "半包装修"
        turl = "banbao"
      elsif tname == "全包装修"
        turl = "quanbao"
      end
      tfurl = "fangshi"
    end
    #if 如果不在这些中，不显示tfurl＝nil || turl=nil
    return [tfurl, turl]
  end
end
