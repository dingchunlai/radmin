module ZhuanquHelper

  def get_zhuanqu_sorts
    sorts = ZhuanquSort.find(:all,:select=>"id,sort_name",:conditions=>"is_delete=0")
    h_sorts = {}
    for sort in sorts
      h_sorts[sort.sort_name] = sort.id.to_i
    end
    return h_sorts
  end

  def get_case_lv1_tags
    tag = Hash.new
    tag[4347] = "户型"
    tag[4348] = "风格"
    tag[4349] = "费用"
    tag[4350] = "装修方式"
    tag[4352] = "装修用途"
    tag[4401] = "案例类别"
    tag[6687] = "颜色"
    tag[9079] = "资讯案例"
    tag[30885] = "家居类别"
    tag[31262] = "特别选项"
    tag[41662] = "产品"
    tag[42160] = "公共空间"
    return tag
  end

  def show_publish_button(is_published, id, zq_type)
    is_published = is_published.to_i; str = "";
    if is_published == 1
      str = "<a href='/zhuanqu/zq_publish?id=#{id}&zq_type=#{zq_type}' target='hideiframe' disabled>已发布</a>"
    else
      str = "<a href='/zhuanqu/zq_publish?id=#{id}&zq_type=#{zq_type}' target='hideiframe'>发布</a>"
    end
    return str
  end

  def get_image_area_by_column_name(ob, cn)
#    @imgs = @imgs.to_s
#    @imgs += ",#{cn}"
    src = ob[cn]
    src = "http://member.51hejia.com/images/nil.gif" if src.to_s.length < 2
    return "<a href='#{src}' target='_blank'><img src='#{src}' width='110' height='80' border='0' /></a> <input type='file' name='#{cn}' size='30' />"
  end

  def show_big_hr
    str = "<hr style='margin-bottom:12px; color:blue' />"
    str += "<div class='formouter' style='padding:0px 0px 25px 480px;'><input value='提交保存' type='submit' style='font-size:18pt' /></div>"
    return str
  end

end
