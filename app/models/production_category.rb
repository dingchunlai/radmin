class ProductionCategory < ActiveRecord::Base
  self.table_name = 'product.production_categories'
  has_and_belongs_to_many :articles,:order =>'ID DESC'

end