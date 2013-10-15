class CreateZhuanquDantus < ActiveRecord::Migration
  def self.up
    create_table :zhuanqu_dantus do |t|
    end
  end

  def self.down
    drop_table :zhuanqu_dantus
  end
end
