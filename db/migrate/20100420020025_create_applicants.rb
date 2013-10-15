class CreateApplicants < ActiveRecord::Migration
  def self.up
    create_table :applicants do |t|
    end
  end

  def self.down
    drop_table :applicants
  end
end
