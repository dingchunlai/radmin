class AskBlogTopicPost < ActiveRecord::Base
  belongs_to :user, :class_name => "HejiaUserBbs", :foreign_key => "user_id"

  belongs_to :topic, :class_name => "AskBlogTopic", :foreign_key => "blog_topic_id"
end