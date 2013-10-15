# == Schema Information
#
# Table name: deco_events
#
#  id               :integer(11)     not null, primary key
#  title            :string(255)
#  dater            :string(255)
#  timer            :string(255)
#  city             :string(255)
#  district         :string(255)
#  address          :string(255)
#  lat              :float
#  lng              :float
#  contact          :string(255)
#  traffic          :string(255)
#  banner_file_name :string(255)
#  summary          :text
#  prompt           :text
#  disclaimer       :text
#  registers_count  :integer(11)
#  registers_end_at :datetime
#  state            :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#  starts_at        :date
#  ends_at          :date
#  style            :integer(4)
#  types            :integer(4)
#  reply_date       :datetime
#

class DecoEvent < Hejia::Db::Hejia
  validates_presence_of :starts_at, :ends_at, :message => "不能为空！"

#  validates_presence_of :lat, :lng
  acts_as_mappable
  acts_as_list :column => 'LIST_INDEX'
  before_validation :geocode_address

  #has_many :registers, :class_name => "DecoRegister", :foreign_key => "event_id"

  def full_address
    "#{city}#{district}#{address} "
  end

  private
  def geocode_address
    geo=GeoKit::Geocoders::MultiGeocoder.geocode(full_address)
    errors.add(:address, "Could not Geocode address") if !geo.success
    self.lat, self.lng = geo.lat,geo.lng if geo.success
  end
end
