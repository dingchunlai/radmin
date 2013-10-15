# == Schema Information
#
# Table name: options
#
#  id          :integer(11)     not null, primary key
#  question_id :integer(11)
#  content     :string(255)
#  is_currect  :boolean(1)
#  created_at  :datetime
#  updated_at  :datetime
#

class Option < ActiveRecord::Base
  belongs_to :question
	validates_presence_of :content
	
	def self.right_options
		self.find(:all,:conditions=>"")
	end
end
