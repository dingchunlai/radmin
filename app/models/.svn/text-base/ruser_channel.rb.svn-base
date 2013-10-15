# == Schema Information
#
# Table name: ruser_channels
#
#  id           :integer(11)     not null, primary key
#  ruser_id     :integer(11)     not null
#  channel_type :integer(11)     not null
#  channel_id   :integer(11)     not null
#

class RuserChannel < ActiveRecord::Base
  self.table_name = "ruser_channels"
  self.primary_key = "id"
  
  belongs_to :r_name,
  :class_name => "User",
  :foreign_key => "ruser_id"
  
  #对应产品
  #belongs_to :p_name,
  #:class_name => "ProductCategory",
  #:foreign_key => "channel_id",
  
  
  #对应问吧
  #belongs_to :a_name,
  #:class_name => "AskForumTag",
  #:foreign_key => "channel_id",
  
  #对应论坛
  #belongs_to :b_name,
  #:class_name => "Tag",
  #:foreign_key => "channel_id",
  
end
