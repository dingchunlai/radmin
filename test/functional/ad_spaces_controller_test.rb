require File.dirname(__FILE__) + '/../test_helper'
require 'ad_spaces_controller'

# Re-raise errors caught by the controller.
class AdSpacesController; def rescue_action(e) raise e end; end

class AdSpacesControllerTest < Test::Unit::TestCase
  def setup
    @controller = AdSpacesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
