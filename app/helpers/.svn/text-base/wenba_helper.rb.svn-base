module WenbaHelper

  def get_tag_name_by_tag_id(tag_id)
    if tag_id.to_i == 0
      "<font color='red'>未知板块</font>"
    else
      WenbaTag.find(tag_id, :select => "name").name rescue "未知板块"
    end
  end

end
