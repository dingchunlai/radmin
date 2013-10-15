class Event < Hejia::Db::Product
  validates_presence_of :name
  validates_presence_of :point
  validates_presence_of :permalink
end
