require File.dirname(__FILE__) + '/../test_helper'
require 'admin_case_controller'

# Re-raise errors caught by the controller.
class AdminCaseController; def rescue_action(e) raise e end; end

class AdminCaseControllerTest < Test::Unit::TestCase
  def setup
    @controller = AdminCaseController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
