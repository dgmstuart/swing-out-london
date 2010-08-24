require 'test_helper'

class OrganisersControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:organisers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create organiser" do
    assert_difference('Organiser.count') do
      post :create, :organiser => { }
    end

    assert_redirected_to organiser_path(assigns(:organiser))
  end

  test "should show organiser" do
    get :show, :id => organisers(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => organisers(:one).to_param
    assert_response :success
  end

  test "should update organiser" do
    put :update, :id => organisers(:one).to_param, :organiser => { }
    assert_redirected_to organiser_path(assigns(:organiser))
  end

  test "should destroy organiser" do
    assert_difference('Organiser.count', -1) do
      delete :destroy, :id => organisers(:one).to_param
    end

    assert_redirected_to organisers_path
  end
end
