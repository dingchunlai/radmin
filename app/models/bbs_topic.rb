class BbsTopic < Hejia::Db::Forum
  def self.select_columns
    return "subject as title, concat('/btopic/',id) as url, id,area_id,subject,tag_id,parent_tag_id,created_at,updated_at"
  end

  def self.new_topics(limit=30, tag_id=0, area_id=0)
    kw_mc = "bbs_topic_new_topics_#{tag_id}_#{area_id}"
    topics = get_mc(kw_mc, 1) do
      cd = ["is_delete = 0"]
      cd << "area_id = #{area_id}" if area_id.to_i != 0
      if tag_id.to_i == 0
      elsif BbsTag.parent_tag_ids.include?(tag_id.to_i)
        cd << "parent_tag_id = #{tag_id}"
      else
        cd << "tag_id = #{tag_id}"
      end
      self.find(:all,:select=>select_columns,:conditions=>cd.join(" and "),:order=>"id desc",:limit=>30)
    end
    return topics[0..limit-1]
  end
  
  def self.hot_topics(limit=5, days=7, tag_id=0, area_id=0, is_good=0)  #hot代表访问量高,cool代表回复数高。
    kw_mc = "bbs_topic_hot_topics_#{days}_#{tag_id}_#{area_id}_#{is_good}"
    topics = get_mc(kw_mc, 1) do
      cd = ["is_delete = 0"]
      cd << "created_at > adddate(now(),-#{days.to_i})" #只查询days天内的帖子
      cd << "area_id = #{area_id}" if area_id.to_i != 0
      cd << "is_good = #{is_good}" if is_good.to_i != 0
      if tag_id.to_i == 0
      elsif BbsTag.parent_tag_ids.include?(tag_id.to_i)
        cd << "parent_tag_id = #{tag_id}"
      else
        cd << "tag_id = #{tag_id}"
      end
      self.find(:all,:select=>select_columns,:conditions=>cd.join(" and "),:order=>"view_counter desc",:limit=>5)
    end
    return topics[0..limit-1]
  end



end
