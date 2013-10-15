# == Schema Information
#
# Table name: 51hejia.hejia_logs
#
#  id          :integer(19)     not null, primary key
#  user_id     :integer(11)
#  event_id    :integer(11)
#  entity_type :integer(11)
#  entity_id   :integer(11)
#  created_at  :datetime
#  updated_at  :datetime
#

class HejiaLog < ActiveRecord::Base
  self.table_name = "51hejia.hejia_logs"
  self.primary_key = "id"
  
  belongs_to :article_author_new,
  :class_name => "User",
  :foreign_key => "user_id"
  
  def self.articlecount(id,begintime,endtime)
    conditions = []
    conditions << "user_id in(#{id}) and entity_type=#{ARTICLE_ADD_ENTITY_TYPE} and event_id=#{ARTICLE_ADD_EVENT_ID}"
    if !endtime.nil?
      conditions << " created_at<='#{endtime}' "
    end
    if !begintime.nil?
      conditions << " created_at>='#{begintime}'"
    end
    count = HejiaLog.count(:all,:select => 'id',:conditions =>conditions.join(" and "))
    return count
  end

  def self.save_log(user_id, entity_id, entity_type, event_id)
    if user_id.to_i > 0 && entity_type.to_i > 0 && event_id.to_i > 0
      HejiaLog.create(:user_id => user_id.to_i, :entity_id => entity_id.to_i, :entity_type => entity_type.to_i, :event_id => event_id.to_i)
    end
  end

end
