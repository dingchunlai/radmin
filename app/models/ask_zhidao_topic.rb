# == Schema Information
#
# Table name: ask_zhidao_topics
#
#  id              :integer(11)     not null, primary key
#  area_id         :integer(11)     not null
#  user_id         :integer(11)
#  tag_id          :integer(11)
#  subject         :string(255)     default(""), not null
#  method          :integer(11)     not null
#  description     :text
#  is_delete       :integer(11)     default(0), not null
#  is_close        :integer(11)     default(0), not null
#  best_post_id    :integer(11)
#  post_counter    :integer(11)     default(1), not null
#  is_vote         :integer(11)     default(0), not null
#  vote_counter    :integer(11)     default(1), not null
#  score           :integer(11)     default(0), not null
#  created_at      :datetime
#  updated_at      :datetime
#  editor_id       :integer(11)
#  is_distribute   :integer(11)     default(0)
#  source          :string(255)
#  source_id       :string(255)
#  view_counter    :integer(11)     default(1), not null
#  guest_email     :string(255)
#  ip              :string(255)
#  guest_name      :string(255)
#  company_id      :integer(11)
#  last_reply_time :datetime
#  supply          :string(1024)
#  interrogee      :integer(11)
#

class AskZhidaoTopic < ActiveRecord::Base
  belongs_to :user, :class_name => "HejiaUserBbs", :foreign_key => "user_id"
end
