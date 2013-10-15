class CreateZhuanquKws < ActiveRecord::Migration
  def self.up
    create_table :zhuanqu_kws do |t|
    end
  end

  def self.down
    drop_table :zhuanqu_kws
  end
end
