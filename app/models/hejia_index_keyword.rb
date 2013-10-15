# == Schema Information
#
# Table name: 51hejia_index.hejia_index_keywords
#
#  id             :integer(11)     not null, primary key
#  name           :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#  entity_counter :integer(11)     default(0), not null
#  zhuanqu        :string(100)
#  inline         :string(100)
#  sameword       :string(100)
#  hot            :string(20)
#  dayflow        :integer(11)
#  keyclass       :integer(11)
#  keytype        :integer(11)
#  fatherid       :integer(11)     default(0)
#  level          :integer(4)      default(1)
#

class HejiaIndexKeyword < ActiveRecord::Base
  set_table_name "51hejia_index.hejia_index_keywords"
end
