# == Schema Information
#
# Table name: participants
#
#  id          :integer(11)     not null, primary key
#  name        :string(255)
#  activity_id :integer(11)
#  tel         :string(255)
#  idcard_id   :string(255)
#  spent_time  :integer(11)
#  created_at  :datetime
#  updated_at  :datetime
#  province    :string(20)
#  city        :string(20)
#

class Participant < ActiveRecord::Base
  
  belongs_to :activity
  validates_presence_of :idcard_id, :on => :create, :message => "身份证号不能为空"
  validates_presence_of :name, :on => :create, :message => "姓名不能为空"
  validates_presence_of :tel, :on => :create, :message => "电话不能为空"
  validates_presence_of :province, :on => :create, :message => "省份不能为空"
  validates_presence_of :city, :on => :create, :message => "城市不能为空"
end
