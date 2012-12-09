require 'test_helper'

class PlayersControllerTest < ActionController::TestCase
  setup do
    @player = players(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:players)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create player" do
    assert_difference('Player.count') do
      post :create, player: { age: @player.age, battingstyle: @player.battingstyle, bowlingstyle: @player.bowlingstyle, bowlingtype: @player.bowlingtype, dob: @player.dob, fname: @player.fname, format: @player.format, formatkey: @player.formatkey, fullname: @player.fullname, lname: @player.lname, playerid: @player.playerid, playertype: @player.playertype, wh_current: @player.wh_current }
    end

    assert_redirected_to player_path(assigns(:player))
  end

  test "should show player" do
    get :show, id: @player
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @player
    assert_response :success
  end

  test "should update player" do
    put :update, id: @player, player: { age: @player.age, battingstyle: @player.battingstyle, bowlingstyle: @player.bowlingstyle, bowlingtype: @player.bowlingtype, dob: @player.dob, fname: @player.fname, format: @player.format, formatkey: @player.formatkey, fullname: @player.fullname, lname: @player.lname, playerid: @player.playerid, playertype: @player.playertype, wh_current: @player.wh_current }
    assert_redirected_to player_path(assigns(:player))
  end

  test "should destroy player" do
    assert_difference('Player.count', -1) do
      delete :destroy, id: @player
    end

    assert_redirected_to players_path
  end
end
