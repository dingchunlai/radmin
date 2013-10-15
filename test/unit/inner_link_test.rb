# == Schema Information
#
# Table name: inner_links
#
#  id         :integer(11)     not null, primary key
#  keyword    :string(24)      default(""), not null
#  url        :string(128)
#  created_at :datetime
#

require File.dirname(__FILE__) + '/../test_helper'

class InnerLinkTest < Test::Unit::TestCase
  fixtures :inner_links

  # Replace this with your real tests.
  def test_truth
    assert false
  end

end
