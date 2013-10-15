# == Schema Information
#
# Table name: siemens_shops
#
#  id         :integer(11)     not null, primary key
#  shengfen   :string(4)
#  dianpu     :string(64)
#  lianxiren  :string(12)
#  dianhua    :string(32)
#  chuanzhen  :string(32)
#  dizhi      :string(64)
#  created_at :datetime
#

class SiemensShop < ActiveRecord::Base
end
