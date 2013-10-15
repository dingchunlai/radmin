# == Schema Information
#
# Table name: jf_commont_result_scores
#
#  id              :integer(11)     not null, primary key
#  commont_id      :integer(11)     default(0), not null
#  content_score   :float
#  real_score      :float
#  important_score :float
#  editor_score    :float
#  active_score    :float
#  result_score    :float
#  cal_date        :datetime
#  update_at       :datetime
#

class JfCommontResultScore < ActiveRecord::Base
end
