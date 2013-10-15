class City < Hejia::Db::Product
  self.table_name = "product_regions"

  has_many :comments, :class_name => "ProductComment", :foreign_key => "city_id"

  acts_as_tree :order => "id"

  def self.province
    self.find(:all, :conditions => "parent_id is null")
  end
end
