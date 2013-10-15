class CreateZhuanquCws < ActiveRecord::Migration
  def self.up
    create_table :zhuanqu_cws do |t|
    end
  end

  def self.down
    drop_table :zhuanqu_cws
  end
end
