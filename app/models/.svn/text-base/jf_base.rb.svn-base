# == Schema Information
#
# Table name: jf_bases
#
#  id        :integer(11)     not null, primary key
#  name      :string(255)
#  keyword   :string(255)
#  keytype   :integer(4)
#  start_num :float
#  end_num   :float
#  value     :float
#  create_at :datetime
#  update_at :datetime
#  status    :integer(4)      default(0)
#  value2    :float
#  value3    :float
#

class JfBase < ActiveRecord::Base

  def self.check_start_num(name,x)
    hub = JfBase.find :all, :select => "id,end_num,start_num", :conditions => ["status = 1 and keyword = ? and keytype=3 and #{x}>= start_num and #{x}<end_num", name]
    return hub
  end
   def self.check_end_num(name,x)
    hub = JfBase.find :all, :select => "id,end_num,start_num", :conditions => ["status = 1 and keyword = ? and keytype=3 and #{x}> start_num and #{x}<=end_num", name]
    return hub
  end
  
  def self.get_keyword
    key = "radmin_jfbase_keyword"
    if CACHE.get(key).nil?
      hub = JfBase.find :all,:select => "id,keyword", :conditions =>"status = 1" ,:group =>"keyword"
      CACHE.set(key, hub)
    else
      hub = CACHE.get(key)
    end
    return hub
  end
  
  def self.kill_keyword_cache
    key = "radmin_jfbase_keyword"
    CACHE.set(key, nil)
  end
end
