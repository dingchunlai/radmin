class CreateQuestions < ActiveRecord::Migration
  def self.up
    create_table :questions do |t|
      t.column(:activity_id, :integer)
      t.column(:title, :string)
      t.column(:category, :integer)
      t.column(:created_at,:datetime)
      t.column(:updated_at,:datetime)  
    end
  end
  
  def self.down
    drop_table :questions
  end
end
