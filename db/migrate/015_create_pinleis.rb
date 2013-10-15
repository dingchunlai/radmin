class CreatePinleis < ActiveRecord::Migration
  def self.up
    create_table :pinleis do |t|
    end
  end

  def self.down
    drop_table :pinleis
  end
end
