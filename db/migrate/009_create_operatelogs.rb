class CreateOperatelogs < ActiveRecord::Migration
  def self.up
    create_table :operatelogs do |t|
      t.column :objid, :integer, :null => false
      t.column :channel, :integer, :null => false
      t.column :stype, :integer, :null => false
      t.column :userid, :integer, :null => false
      t.column :optype, :integer, :null => false
      t.column :createdate, :timestamp, :null => false
    end
  end

  def self.down
    drop_table :operatelogs
  end
end
