module WordmanagerHelper
  def getleadword(id)
    count_key = "key_keyword#{id}_key_#{Time.now.strftime('%Y%m%d')}"
    if CACHE.get(count_key).nil?
      keyw = HejiaIndexKeyword.find(:first, :conditions => ["id in (?)",id])
      unless keyw.blank?
        wor = keyw.name
        CACHE.set(count_key, wor)
      end
    else
      wor = CACHE.get(count_key)
    end
    return wor
  end 
  
  def sameword(id)
    if id.to_s!="0"
      count_key = "key_sameword#{id}_key_#{Time.now.strftime('%Y%m%d')}"
      wor=""
      if CACHE.get(count_key).nil?
        keyw = HejiaIndexKeyword.find(:all,:conditions=>"sameword=#{id}")
        keyw.each do |k|
          wor += k.name+","
        end
        CACHE.set(count_key, wor)
      else
        wor = CACHE.get(count_key)
      end
      return wor
    else
      return "无同义字"
    end
  end
  def countword(id)
    count_key = "key_1countkey#{id}_key_#{Time.now.strftime('%Y%m%d')}"
    keyw = 0
    if CACHE.get(count_key).nil?
      keyw  = Relation.count(:conditions => ["keyword_id = ?", id])
      CACHE.set(count_key, keyw)
    else
      keyw = CACHE.get(count_key)
    end
    return keyw
  end
end
