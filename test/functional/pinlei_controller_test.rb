require File.dirname(__FILE__) + '/../test_helper'
require 'pinlei_controller'

# Re-raise errors caught by the controller.
class PinleiController; def rescue_action(e) raise e end; end

class PinleiControllerTest < Test::Unit::TestCase
  def setup
    @controller = PinleiController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
