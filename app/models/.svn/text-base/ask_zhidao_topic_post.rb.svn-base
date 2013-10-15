# == Schema Information
#
# Table name: ask_zhidao_topic_posts
#
#  id              :integer(11)     not null, primary key
#  zhidao_topic_id :integer(11)     not null
#  user_id         :integer(11)
#  content         :text
#  vote_counter    :integer(11)     default(1), not null
#  is_delete       :integer(11)     default(0), not null
#  created_at      :datetime
#  updated_at      :datetime
#  method          :integer(11)     not null
#  editor_id       :integer(11)
#  guest_email     :string(255)
#  ip              :string(255)
#  guest_name      :string(255)
#  expert          :integer(4)      default(0), not null
#  is_best_post    :integer(4)      default(0), not null
#

class AskZhidaoTopicPost < ActiveRecord::Base
  belongs_to :topic, :class_name => "AskZhidaoTopic", :foreign_key => "zhidao_topic_id"
  belongs_to :user, :class_name => "HejiaUserBbs", :foreign_key => "user_id"
end
