#敏感词过滤
class BadWord
  def self.all key
    REDIS_DB.smembers(key) || []
  end
   
  def self.find(key , member)
    member if REDIS_DB.sismember(key , member)
  end
   
  def self.like(member)
    self.all.select{|word| word =~ /#{member}/}
  end
  
  def self.create(key , value)
    REDIS_DB.sadd(key , value)
  end
  
  def self.destroy(key , value)
    REDIS_DB.srem(key , value)
  end
 
end
