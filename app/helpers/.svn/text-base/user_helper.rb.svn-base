module UserHelper
  def get_formselect_user(name, first, attrib, selectedvalues)
    str = "<select name='#{name}[]' id='#{name}' #{attrib}>"
    str += "<option value=''>#{first}</option>" unless strip(first)==""

    hash = get_webpm(name)

    is_admin = current_staff.admin?

    hash.each do |k, v|
      if (v != "管理员" && v !="后台维护") || is_admin
          if selectedvalues.include?(trim(k.to_s))
            str += "<option value='#{k}' selected>#{v}</option>"
          else
            str += "<option value='#{k}'>#{v}</option>"
          end
      end
    end
    return str += "</select>"
  end
end
