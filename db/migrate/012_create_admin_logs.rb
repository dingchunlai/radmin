class CreateAdminLogs < ActiveRecord::Migration
  def self.up
    create_table :admin_logs do |t|
    end
  end

  def self.down
    drop_table :admin_logs
  end
end
