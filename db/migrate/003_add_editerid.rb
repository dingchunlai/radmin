class AddEditerid < ActiveRecord::Migration
  def self.up
    add_column :radmin_users, :editer_id ,:integer
  end

  def self.down
    remove_column :radmin_users, :editer_id
  end
end
