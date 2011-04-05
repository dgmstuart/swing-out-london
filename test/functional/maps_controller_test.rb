require 'test_helper'

class MapsControllerTest < ActionController::TestCase
  test "should get lindy_map" do
    get :lindy_map
    assert_response :success
  end

end
