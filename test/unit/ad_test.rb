# == Schema Information
#
# Table name: radmin_ads
#
#  id         :integer(11)     not null, primary key
#  customer   :string(255)
#  position   :string(255)
#  pageid     :integer(11)     default(0), not null
#  pagename   :string(255)
#  starttime  :datetime
#  endtime    :datetime
#  editor     :string(255)
#  created_at :datetime
#  updated_at :datetime
#  view_code  :string(999)
#  click_code :string(999)
#  scale      :integer(11)     default(0), not null
#

require File.dirname(__FILE__) + '/../test_helper'

class AdTest < Test::Unit::TestCase
  fixtures :ads

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
