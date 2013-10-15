module FormHelper
  def get_form_element(sn, ctype, ovalue, dvalue)
    rv = ""
    #=@f_ctype[col.ctype]
    case(ctype)
    when 1  #单项选择
        for ov in ovalue.split(",")
          if trim(ov) == trim(dvalue)
            dv = "checked"
          else
            dv = ""
          end
          rv += "<dd><input type=\"radio\" name=\"c#{sn}\" #{dv} value=\"#{ov}\" /> #{ov}</dd>"
        end
    when 2  #多项选择
        i = 0
        for ov in ovalue.split(",")
          if trim(ov) == trim(dvalue)
            dv = "checked"
          else
            dv = ""
          end
          rv += "<dd><input type=\"checkbox\" name=\"c#{sn}[]\" #{dv} value=\"#{ov}\" /> #{ov}</dd> "
          i += 1
        end    
    when 3  #下拉菜单
        rv += "<select name=\"c#{sn}\" id=\"c#{sn}\">"
        for ov in ovalue.split(",")
          if trim(ov) == trim(dvalue)
            dv = "selected"
          else
            dv = ""
          end
          rv += "<option value=\"#{ov}\" #{dv}>#{ov}</option>"
        end
        rv += "</select>"
    when 4  #长文本
        rv += "<textarea name=\"c#{sn}\" id=\"c#{sn}\" style=\"width:400px;height:120px;\">#{dvalue}</textarea>"
    when 5 #文件上传
        rv += "<input type=\"file\" name=\"c#{sn}\" id=\"c#{sn}\" style=\"width:220px;\" />"
    else  #字符串
        rv += "<dd><input type=\"text\" name=\"c#{sn}\" id=\"c#{sn}\" style=\"width:220px;\" value=\"#{dvalue}\" /></dd>"
    end
    return rv
  end
end
