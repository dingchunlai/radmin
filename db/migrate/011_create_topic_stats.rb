class CreateTopicStats < ActiveRecord::Migration
  def self.up
    create_table :topic_stats do |t|
    end
  end

  def self.down
    drop_table :topic_stats
  end
end
