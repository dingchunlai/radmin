# == Schema Information
#
# Table name: booking_decos
#
#  id               :integer(11)     not null, primary key
#  name             :string(255)
#  address          :string(255)
#  zip_code         :string(255)
#  location         :integer(11)
#  xiaoqu_name      :string(255)
#  tel              :string(255)
#  email            :string(255)
#  preview_time     :datetime
#  city_id          :integer(11)
#  region_id        :integer(11)
#  fang             :string(255)
#  ting             :string(255)
#  wei              :string(255)
#  building_area    :integer(11)
#  house_photo_path :string(255)
#  deco_type        :integer(11)
#  deco_requirement :string(255)
#  deco_id          :integer(11)
#  status           :integer(11)     default(0)
#  identifying_code :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#

class BookingDeco < ActiveRecord::Base
  belongs_to :city,
  :class_name => "ArticleTag",
  :foreign_key => "city_id"
  
  belongs_to :region,
  :class_name => "ArticleTag",
  :foreign_key => "region_id"  
end
