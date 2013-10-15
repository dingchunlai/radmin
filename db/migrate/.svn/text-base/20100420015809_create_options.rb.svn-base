class CreateOptions < ActiveRecord::Migration
  def self.up
    create_table :options do |t|
      t.column(:question_id, :integer)
			t.column(:content, :string)
			t.column(:is_currect, :boolean)
		  t.column(:created_at,:datetime)
      t.column(:updated_at,:datetime)
    end
  end
  
  def self.down
    drop_table :options
  end
end
