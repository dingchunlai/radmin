class CreateSiemensShops < ActiveRecord::Migration
  def self.up
    create_table :siemens_shops do |t|
    end
  end

  def self.down
    drop_table :siemens_shops
  end
end
