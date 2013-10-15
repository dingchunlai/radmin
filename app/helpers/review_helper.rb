module ReviewHelper
  
  def cooperation(company_cooperation)
    case company_cooperation
    when 1 ; "合作"
    when 0 ; "非合作"
    when -1 ; "意向"
    end
  end

  #生成日记地址
  def genration_diary_path diary_id
    diary = DecorationDiary.find diary_id
    city_area = generate_firm_city_area diary.deco_firm_id
    city = TAGURLS[city_area[0]]
    "http://z.#{city}.51hejia.com/gs-#{diary.deco_firm_id}/zhuangxiugushi/#{diary.id}"
  end

  TAGURLS = {
    0 => "",
    11910 => "shanghai",
    12117 => "suzhou",
    12122 => "nanjing",
    12301 => "ningbo",
    12306 => "hangzhou",
    12118 => "wuxi"
  }

  def generate_firm_city_area firm_id
    city_and_area = []
    firm = DecoFirm.find firm_id
    if firm.city.to_i == 11910
      city_and_area << firm.city
      city_and_area << firm.district
    else
      city_and_area <<  firm.district
      city_and_area <<  firm.area
    end
    city_and_area
  end

  def city_name city_id
    user = HejiaUserBbs.find_by_USERBBSID(city_id)
    if user
      if Tag.find_by_TAGID(user.CITY)
        if Tag.find_by_TAGID(user.CITY).TAGFATHERID == 11910
        "上海"
        else
          Tag.find_by_TAGID(user.CITY).TAGNAME
        end
      else
        '--'
      end
    end
  end

end