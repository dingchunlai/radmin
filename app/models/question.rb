# == Schema Information
#
# Table name: questions
#
#  id          :integer(11)     not null, primary key
#  activity_id :integer(11)
#  title       :string(255)
#  category    :integer(11)
#  created_at  :datetime
#  updated_at  :datetime
#

class Question < ActiveRecord::Base
  belongs_to :activity 
  has_many :options   ,:dependent => :destroy 
  validates_presence_of :title
end
