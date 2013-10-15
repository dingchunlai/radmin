# == Schema Information
#
# Table name: basslogdatas
#
#  id     :integer(11)     not null, primary key
#  dtype  :integer(11)
#  dname  :string(255)
#  dvalue :string(255)
#  state  :integer(11)     not null
#

class Basslogdata < ActiveRecord::Base
  def self.getArticleData
    return find(:all,:conditions => "dtype='1' and state='1'")
  end
end
