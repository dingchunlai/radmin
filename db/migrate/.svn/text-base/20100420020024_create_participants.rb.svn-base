class CreateParticipants < ActiveRecord::Migration
  def self.up
    create_table :participants do |t|
    	t.column(:name, :string)
    	t.column(:activity_id, :integer)
    	t.column(:tel, :string)
    	t.column(:post_id, :string)
    	t.column(:time, :integer)
			t.column(:created_at,:datetime)
      t.column(:updated_at,:datetime)
    end
  end
  
  def self.down
    drop_table :participants
  end
end
