# == Schema Information
#
# Table name: deco_quotations
#
#  id         :integer(11)     not null, primary key
#  title      :string(500)
#  textarea   :text
#  created_at :datetime
#  updated_at :datetime
#

class DecoQuotation < ActiveRecord::Base
  has_and_belongs_to_many :firms, :class_name => "DecoFirm",
								:join_table => "deco_firms_quotations",
								:foreign_key => "quotation_id",
								:association_foreign_key => "firm_id",
                                :uniq => true
end
