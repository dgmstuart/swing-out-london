require 'test_helper'

class VenuesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:venues)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create venue" do
    assert_difference('Venue.count') do
      post :create, :venue => { }
    end

    assert_redirected_to venue_path(assigns(:venue))
  end

  test "should show venue" do
    get :show, :id => venues(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => venues(:one).to_param
    assert_response :success
  end

  test "should update venue" do
    put :update, :id => venues(:one).to_param, :venue => { }
    assert_redirected_to venue_path(assigns(:venue))
  end

  test "should destroy venue" do
    assert_difference('Venue.count', -1) do
      delete :destroy, :id => venues(:one).to_param
    end

    assert_redirected_to venues_path
  end
end
