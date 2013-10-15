# == Schema Information
#
# Table name: ruser_husers
#
#  id       :integer(11)     not null, primary key
#  ruser_id :integer(11)     not null
#  huser_id :integer(11)     not null
#

class RuserHuser < ActiveRecord::Base
  self.table_name = "ruser_husers"
  
  belongs_to :r_name,
  :class_name => "User",
  :foreign_key => "ruser_id"
  
  belongs_to :b_name,
  :class_name => "HejiaUserBbs",
  :foreign_key => "huser_id"
end
