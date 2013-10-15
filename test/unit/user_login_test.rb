# == Schema Information
#
# Table name: radmin_user_logins
#
#  id         :integer(11)     not null, primary key
#  user_id    :integer(11)     not null
#  login_date :integer(11)     not null
#  created_at :datetime        not null
#

require File.dirname(__FILE__) + '/../test_helper'

class UserLoginTest < Test::Unit::TestCase
  fixtures :user_logins

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
