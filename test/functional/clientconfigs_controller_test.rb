require 'test_helper'

class ClientconfigsControllerTest < ActionController::TestCase
  setup do
    @clientconfig = clientconfigs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:clientconfigs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create clientconfig" do
    assert_difference('Clientconfig.count') do
      post :create, clientconfig: { avg: @clientconfig.avg, bbb: @clientconfig.bbb, bbh: @clientconfig.bbh, byes: @clientconfig.byes, clientkey: @clientconfig.clientkey, covrsnratio: @clientconfig.covrsnratio, dsmsl: @clientconfig.dsmsl, extras: @clientconfig.extras, five: @clientconfig.five, four: @clientconfig.four, inns: @clientconfig.inns, legbyes: @clientconfig.legbyes, mtchlost: @clientconfig.mtchlost, mtchwon: @clientconfig.mtchwon, noballs: @clientconfig.noballs, one: @clientconfig.one, runs: @clientconfig.runs, six: @clientconfig.six, sr: @clientconfig.sr, three: @clientconfig.three, two: @clientconfig.two, wides: @clientconfig.wides, zero: @clientconfig.zero }
    end

    assert_redirected_to clientconfig_path(assigns(:clientconfig))
  end

  test "should show clientconfig" do
    get :show, id: @clientconfig
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @clientconfig
    assert_response :success
  end

  test "should update clientconfig" do
    put :update, id: @clientconfig, clientconfig: { avg: @clientconfig.avg, bbb: @clientconfig.bbb, bbh: @clientconfig.bbh, byes: @clientconfig.byes, clientkey: @clientconfig.clientkey, covrsnratio: @clientconfig.covrsnratio, dsmsl: @clientconfig.dsmsl, extras: @clientconfig.extras, five: @clientconfig.five, four: @clientconfig.four, inns: @clientconfig.inns, legbyes: @clientconfig.legbyes, mtchlost: @clientconfig.mtchlost, mtchwon: @clientconfig.mtchwon, noballs: @clientconfig.noballs, one: @clientconfig.one, runs: @clientconfig.runs, six: @clientconfig.six, sr: @clientconfig.sr, three: @clientconfig.three, two: @clientconfig.two, wides: @clientconfig.wides, zero: @clientconfig.zero }
    assert_redirected_to clientconfig_path(assigns(:clientconfig))
  end

  test "should destroy clientconfig" do
    assert_difference('Clientconfig.count', -1) do
      delete :destroy, id: @clientconfig
    end

    assert_redirected_to clientconfigs_path
  end
end
