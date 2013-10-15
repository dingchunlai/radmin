class CreateUser < ActiveRecord::Migration
  def self.up
    create_table :radmin_users do |t|
      t.column(:name, :string, :limit => 127, :default => '', :null => false)
      t.column(:password, :string, :limit => 127, :default => '', :null => false)
      t.column(:rname, :string, :limit => 127, :null => true)
      t.column(:cdate, :datetime, :null => true)
      t.column(:udate, :datetime, :null => true)
      t.column(:idate, :datetime, :null => true)
      t.column(:role, :string, :limit => 127, :default => '0', :null => false)
      t.column(:description, :string, :limit => 255, :null => true)
      t.column(:login_num, :integer, :default => 0, :null => false)
      t.column(:last_login, :datetime, :null => true)
    end
  end

  def self.down
    drop_table :radmin_users
  end
end
