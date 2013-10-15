# == Schema Information
#
# Table name: zhuanqu_cws
#
#  id           :integer(11)     not null, primary key
#  tagname      :string(64)
#  kw1          :string(64)
#  kw2          :string(64)
#  sort_id1     :integer(11)
#  sort_id2     :integer(11)
#  is_confirmed :integer(4)      default(0), not null
#  created_at   :datetime
#  updated_at   :datetime
#  case_num     :integer(11)     default(-1)
#  c1           :integer(11)     default(0)
#  c2           :string(128)
#

require File.dirname(__FILE__) + '/../test_helper'

class ZhuanquCwTest < Test::Unit::TestCase
  fixtures :zhuanqu_cws

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
