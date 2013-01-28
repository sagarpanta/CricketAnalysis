require 'test_helper'

class ExternalsControllerTest < ActionController::TestCase
  setup do
    @external = externals(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:externals)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create external" do
    assert_difference('External.count') do
      post :create, external: { _over: @external._over, ballnum: @external.ballnum, balltype: @external.balltype, beaten: @external.beaten, bowler: @external.bowler, bowlingend: @external.bowlingend, bowlingside: @external.bowlingside, extras: @external.extras, fielder: @external.fielder, length: @external.length, line: @external.line, nonstriker: @external.nonstriker, releaseshot: @external.releaseshot, runs: @external.runs, shottype: @external.shottype, striker: @external.striker, uncomfortable: @external.uncomfortable, wicket: @external.wicket }
    end

    assert_redirected_to external_path(assigns(:external))
  end

  test "should show external" do
    get :show, id: @external
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @external
    assert_response :success
  end

  test "should update external" do
    put :update, id: @external, external: { _over: @external._over, ballnum: @external.ballnum, balltype: @external.balltype, beaten: @external.beaten, bowler: @external.bowler, bowlingend: @external.bowlingend, bowlingside: @external.bowlingside, extras: @external.extras, fielder: @external.fielder, length: @external.length, line: @external.line, nonstriker: @external.nonstriker, releaseshot: @external.releaseshot, runs: @external.runs, shottype: @external.shottype, striker: @external.striker, uncomfortable: @external.uncomfortable, wicket: @external.wicket }
    assert_redirected_to external_path(assigns(:external))
  end

  test "should destroy external" do
    assert_difference('External.count', -1) do
      delete :destroy, id: @external
    end

    assert_redirected_to externals_path
  end
end
