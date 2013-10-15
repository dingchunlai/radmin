require File.dirname(__FILE__) + '/../test_helper'
require 'ruser_channel_controller'

# Re-raise errors caught by the controller.
class RuserChannelController; def rescue_action(e) raise e end; end

class RuserChannelControllerTest < Test::Unit::TestCase
  def setup
    @controller = RuserChannelController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
