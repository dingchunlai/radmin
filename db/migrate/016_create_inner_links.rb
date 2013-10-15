class CreateInnerLinks < ActiveRecord::Migration
  def self.up
    create_table :inner_links do |t|
    end
  end

  def self.down
    drop_table :inner_links
  end
end
