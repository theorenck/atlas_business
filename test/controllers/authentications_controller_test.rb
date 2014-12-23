require 'test_helper'

class AuthenticationsControllerTest < ActionController::TestCase
  setup do
    @authentication = authentications(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:authentications)
  end

  test "should create authentication" do
    assert_difference('Authentication.count') do
      post :create, authentication: {  }
    end

    assert_response 201
  end

  test "should show authentication" do
    get :show, id: @authentication
    assert_response :success
  end

  test "should update authentication" do
    put :update, id: @authentication, authentication: {  }
    assert_response 204
  end

  test "should destroy authentication" do
    assert_difference('Authentication.count', -1) do
      delete :destroy, id: @authentication
    end

    assert_response 204
  end
end
