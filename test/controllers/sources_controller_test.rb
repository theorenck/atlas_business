require 'test_helper'

class SourcesControllerTest < ActionController::TestCase
  setup do
    @source = sources(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:sources)
  end

  test "should create source" do
    assert_difference('Source.count') do
      post :create, source: { code: @source.code }
    end

    assert_response 201
  end

  test "should show source" do
    get :show, id: @source
    assert_response :success
  end

  test "should update source" do
    put :update, id: @source, source: { code: @source.code }
    assert_response 204
  end

  test "should destroy source" do
    assert_difference('Source.count', -1) do
      delete :destroy, id: @source
    end

    assert_response 204
  end
end
