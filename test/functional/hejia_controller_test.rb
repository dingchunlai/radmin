require File.dirname(__FILE__) + '/../test_helper'
require 'hejia_controller'

# Re-raise errors caught by the controller.
class HejiaController; def rescue_action(e) raise e end; end

class HejiaControllerTest < Test::Unit::TestCase
  def setup
    @controller = HejiaController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
