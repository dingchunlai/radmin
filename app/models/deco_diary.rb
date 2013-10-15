# == Schema Information
#
# Table name: deco_diaries
#
#  id         :integer(11)     not null, primary key
#  firm_id    :integer(11)
#  owner      :string(255)
#  title      :string(255)
#  url        :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class DecoDiary < ActiveRecord::Base
  belongs_to :firm, :class_name => "DecoFirm", :foreign_key => "firm_id"
end
