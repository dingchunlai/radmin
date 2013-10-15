class CreateCommunityUsers < ActiveRecord::Migration
  def self.up
    create_table :community_users do |t|
    end
  end

  def self.down
    drop_table :community_users
  end
end
