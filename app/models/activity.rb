# == Schema Information
#
# Table name: activities
#
#  id         :integer(11)     not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Activity < ActiveRecord::Base
  has_many :questions ,:dependent => :destroy 
  has_many :participants
  validates_presence_of :name
  
end
