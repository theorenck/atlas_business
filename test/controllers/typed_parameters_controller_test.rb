require 'test_helper'

class TypedParametersControllerTest < ActionController::TestCase
  setup do
    @typed_parameter = typed_parameters(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:typed_parameters)
  end

  test "should create typed_parameter" do
    assert_difference('TypedParameter.count') do
      post :create, typed_parameter: { datatype: @typed_parameter.datatype, evaluated: @typed_parameter.evaluated }
    end

    assert_response 201
  end

  test "should show typed_parameter" do
    get :show, id: @typed_parameter
    assert_response :success
  end

  test "should update typed_parameter" do
    put :update, id: @typed_parameter, typed_parameter: { datatype: @typed_parameter.datatype, evaluated: @typed_parameter.evaluated }
    assert_response 204
  end

  test "should destroy typed_parameter" do
    assert_difference('TypedParameter.count', -1) do
      delete :destroy, id: @typed_parameter
    end

    assert_response 204
  end
end
