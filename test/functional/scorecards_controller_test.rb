require 'test_helper'

class ScorecardsControllerTest < ActionController::TestCase
  setup do
    @scorecard = scorecards(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:scorecards)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create scorecard" do
    assert_difference('Scorecard.count') do
      post :create, scorecard: { ballsbeforeboundary: @scorecard.ballsbeforeboundary, ballsbeforerun: @scorecard.ballsbeforerun, ballsdelivered: @scorecard.ballsdelivered, ballsfaced: @scorecard.ballsfaced, batsmankey: @scorecard.batsmankey, battingendkey: @scorecard.battingendkey, battingposition: @scorecard.battingposition, bowlerkey: @scorecard.bowlerkey, bowlingendkey: @scorecard.bowlingendkey, bowlingposition: @scorecard.bowlingposition, byes: @scorecard.byes, currentnonstrikerkey: @scorecard.currentnonstrikerkey, currentstrikerkey: @scorecard.currentstrikerkey, dismissedbatsmankey: @scorecard.dismissedbatsmankey, eights: @scorecard.eights, fielderkey: @scorecard.fielderkey, fives: @scorecard.fives, formatkey: @scorecard.formatkey, fours: @scorecard.fours, inning: @scorecard.inning, legbyes: @scorecard.legbyes, maiden: @scorecard.maiden, matchkey: @scorecard.matchkey, noballs: @scorecard.noballs, ones: @scorecard.ones, others: @scorecard.others, outbywk: @scorecard.outbywk, outtypekey: @scorecard.outtypekey, runs: @scorecard.runs, sevens: @scorecard.sevens, sixes: @scorecard.sixes, teamidone: @scorecard.teamidone, teamtwoid: @scorecard.teamtwoid, threes: @scorecard.threes, tournamentkey: @scorecard.tournamentkey, twos: @scorecard.twos, venuekey: @scorecard.venuekey, wicket: @scorecard.wicket, wides: @scorecard.wides, zeros: @scorecard.zeros }
    end

    assert_redirected_to scorecard_path(assigns(:scorecard))
  end

  test "should show scorecard" do
    get :show, id: @scorecard
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @scorecard
    assert_response :success
  end

  test "should update scorecard" do
    put :update, id: @scorecard, scorecard: { ballsbeforeboundary: @scorecard.ballsbeforeboundary, ballsbeforerun: @scorecard.ballsbeforerun, ballsdelivered: @scorecard.ballsdelivered, ballsfaced: @scorecard.ballsfaced, batsmankey: @scorecard.batsmankey, battingendkey: @scorecard.battingendkey, battingposition: @scorecard.battingposition, bowlerkey: @scorecard.bowlerkey, bowlingendkey: @scorecard.bowlingendkey, bowlingposition: @scorecard.bowlingposition, byes: @scorecard.byes, currentnonstrikerkey: @scorecard.currentnonstrikerkey, currentstrikerkey: @scorecard.currentstrikerkey, dismissedbatsmankey: @scorecard.dismissedbatsmankey, eights: @scorecard.eights, fielderkey: @scorecard.fielderkey, fives: @scorecard.fives, formatkey: @scorecard.formatkey, fours: @scorecard.fours, inning: @scorecard.inning, legbyes: @scorecard.legbyes, maiden: @scorecard.maiden, matchkey: @scorecard.matchkey, noballs: @scorecard.noballs, ones: @scorecard.ones, others: @scorecard.others, outbywk: @scorecard.outbywk, outtypekey: @scorecard.outtypekey, runs: @scorecard.runs, sevens: @scorecard.sevens, sixes: @scorecard.sixes, teamidone: @scorecard.teamidone, teamtwoid: @scorecard.teamtwoid, threes: @scorecard.threes, tournamentkey: @scorecard.tournamentkey, twos: @scorecard.twos, venuekey: @scorecard.venuekey, wicket: @scorecard.wicket, wides: @scorecard.wides, zeros: @scorecard.zeros }
    assert_redirected_to scorecard_path(assigns(:scorecard))
  end

  test "should destroy scorecard" do
    assert_difference('Scorecard.count', -1) do
      delete :destroy, id: @scorecard
    end

    assert_redirected_to scorecards_path
  end
end
