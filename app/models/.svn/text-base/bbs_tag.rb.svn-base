class BbsTag < Hejia::Db::Forum
  def self.parent_tag_ids
    PARENT_TAG_IDS.split(",").collect { |e| e.to_i }
  end

  def self.get_tag_ids_by_parent_id(parent_id, limit=99)
    kw_mc = "bbs_tag_ids_by_parent_id_#{parent_id}"
    tags = get_mc(kw_mc) do
      self.find(:all,:select=>"id",:conditions=>["parent_id = ?", parent_id],:order=>"ordernum").collect { |e| e["id"] }
    end
    return tags[0..limit-1]
  end

  def self.get_tag_name_by_tag_id(tag_id)
    kw_mc = "bbs_tag_name_by_tag_id_#{tag_id}"
    tag_name = get_mc(kw_mc) do
      self.find(tag_id,:select=>"name")["name"] rescue "unknow_tag_name"
    end
    return tag_name
  end

  def self.get_tag_id_by_tag_name(tag_name)
    kw_mc = "bbs_tag_id_by_tag_name_#{tag_name}"
    tag_id = get_mc(kw_mc) do
      self.find_by_name(tag_name,:select=>"id")["id"] rescue 0
    end
    return tag_id
  end
end
