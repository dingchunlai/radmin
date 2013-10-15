module DecoFirmsStatisticsHelper


  def get_diaries_count_is_hejia_user(is_by_time,begintime,endtime,firm_id)
    conditions = []
    conditions << "d.updated_at >= '#{begintime.to_time.to_s(:db)}'" unless begintime.blank?
    conditions << "d.updated_at <= '#{endtime.to_time.tomorrow.to_s(:db)}'" unless endtime.blank?
    if conditions.size == 1
      query = conditions.join
    elsif conditions.size > 1
      query = conditions.join(' and ')
    else
      query = nil
    end

    if is_by_time
      @d_count = DecorationDiary.find_by_sql("SELECT count(d.id) as c FROM 51hejia.decoration_diaries d ,51hejia.HEJIA_USER_BBS u, 51hejia.radmin_users r where d.user_id=u.USERBBSID and u.user_id=r.id and #{query} and d.deco_firm_id=#{firm_id}")
    else
      @d_count = DecorationDiary.find_by_sql("SELECT count(d.id) as c FROM 51hejia.decoration_diaries d ,51hejia.HEJIA_USER_BBS u, 51hejia.radmin_users r where d.user_id=u.USERBBSID and u.user_id=r.id and d.deco_firm_id=#{firm_id}")
    end
  end


end
