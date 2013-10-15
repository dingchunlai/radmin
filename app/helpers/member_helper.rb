module MemberHelper
  def get_last_photo_by_note_id(id)
    userphoto = UserPhoto.find(:first, :select => "imageurl,stage,title", :conditions => "note_id = #{id} and status = 1", :order => "id desc")
    return userphoto
  end
  def compre(c_date,now_date)
    str = ""
    yea = now_date.year().to_i - c_date.year().to_i
    mon = now_date.month().to_i - c_date.month().to_i
    da = now_date.day().to_i - c_date.day().to_i
    if now_date.year() == c_date.year()
      if mon > 3
        str = "/member/user_note_new"
      elsif mon == 3
        if da > 0
          str = "/member/user_note_new"
        else
          str = "javascript:alert('请三个月之后再新建日记!');"
        end
      else
        str = "javascript:alert('请三个月之后再新建日记!');"
      end 
    else
      if yea == 1
        if mon == 9
          if da > 0
            str = "/member/user_note_new"
          else
            str = "javascript:alert('请三个月之后再新建日记!');"
          end
        elsif mon < 9
          str = "/member/user_note_new"
        else
          str = "javascript:alert('请三个月之后再新建日记!');"
        end 
      else
        str = "/member/user_note_new"
      end
    end
    return str
  end
end
