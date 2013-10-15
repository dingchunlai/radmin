class CreateAskZhidaoTopicPosts < ActiveRecord::Migration
  def self.up
    create_table :ask_zhidao_topic_posts do |t|
    end
  end

  def self.down
    drop_table :ask_zhidao_topic_posts
  end
end
