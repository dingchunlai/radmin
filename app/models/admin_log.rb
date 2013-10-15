class AdminLog < Hejia::Db::Forum
  belongs_to :editor, :class_name => "HejiaUserBbs", :foreign_key => "editor_id"
  belongs_to :user, :class_name => "HejiaUserBbs", :foreign_key => "user_id"
  belongs_to :topic, :class_name => "BbsTopic", :foreign_key => "topic_id"
end
