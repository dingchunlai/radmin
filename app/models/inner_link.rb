# == Schema Information
#
# Table name: inner_links
#
#  id         :integer(11)     not null, primary key
#  keyword    :string(24)      default(""), not null
#  url        :string(128)
#  created_at :datetime
#

class InnerLink < ActiveRecord::Base
  
end
