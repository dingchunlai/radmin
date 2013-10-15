class CreateOperatelogscores < ActiveRecord::Migration
  def self.up
    create_table :operatelogscores do |t|
      t.column :channel, :integer, :null => false
      t.column :stype, :integer, :null => false
      t.column :userid, :integer, :null => false
      t.column :score, :integer, :null => false
      t.column :createdate, :timestamp, :null => false
      t.column :timestr, :string, :null => false
    end
  end

  def self.down
    drop_table :operatelogscores
  end
end
