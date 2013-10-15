require File.dirname(__FILE__) + '/../test_helper'
require 'bardiss_controller'

# Re-raise errors caught by the controller.
class BardissController; def rescue_action(e) raise e end; end

class BardissControllerTest < Test::Unit::TestCase
  def setup
    @controller = BardissController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
