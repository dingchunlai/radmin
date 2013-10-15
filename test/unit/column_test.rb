# == Schema Information
#
# Table name: radmin_columns
#
#  id        :integer(11)     not null, primary key
#  formid    :integer(11)
#  cname     :string(255)
#  ctype     :integer(4)      default(1), not null
#  sn        :integer(4)
#  dvalue    :string(999)
#  ovalue    :string(999)
#  remark    :string(999)
#  mustfill  :boolean(1)      default(FALSE), not null
#  sep_type  :integer(11)
#  sep_value :string(255)
#

require File.dirname(__FILE__) + '/../test_helper'

class ColumnTest < Test::Unit::TestCase
  fixtures :columns

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
