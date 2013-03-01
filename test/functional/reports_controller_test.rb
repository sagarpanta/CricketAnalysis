require 'test_helper'

class ReportsControllerTest < ActionController::TestCase
  setup do
    @report = reports(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:reports)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create report" do
    assert_difference('Report.count') do
      post :create, report: { akey: @report.akey, ankey1: @report.ankey1, blkey1: @report.blkey1, blp1: @report.blp1, bls1: @report.bls1, bp1: @report.bp1, bp: @report.bp, bskey1: @report.bskey1, btkey: @report.btkey, btn1: @report.btn1, bts1: @report.bts1, bts: @report.bts, chkey1: @report.chkey1, chkey: @report.chkey, ckey1: @report.ckey1, ckey: @report.ckey, ekey1: @report.ekey1, ekey: @report.ekey, fkey1: @report.fkey1, fkey: @report.fkey, fq: @report.fq, fxb: @report.fxb, group1: @report.group1, group2: @report.group2, inn1: @report.inn1, inn: @report.inn, lk1: @report.lk1, lnk1: @report.lnk1, lxb: @report.lxb, lxm: @report.lxm, metric: @report.metric, mkey1: @report.mkey1, mkey: @report.mkey, mtkey1: @report.mtkey1, mtkey: @report.mtkey, pckey1: @report.pckey1, pckey: @report.pckey, ptname1: @report.ptname1, ptname: @report.ptname, reportname: @report.reportname, sd: @report.sd, spkey1: @report.spkey1, st: @report.st, tkey1: @report.tkey1, tkey: @report.tkey, tmkey1: @report.tmkey1, tmkey: @report.tmkey, ttkey1: @report.ttkey1, ttkey: @report.ttkey, vid: @report.vid, vkey1: @report.vkey1, vkey: @report.vkey }
    end

    assert_redirected_to report_path(assigns(:report))
  end

  test "should show report" do
    get :show, id: @report
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @report
    assert_response :success
  end

  test "should update report" do
    put :update, id: @report, report: { akey: @report.akey, ankey1: @report.ankey1, blkey1: @report.blkey1, blp1: @report.blp1, bls1: @report.bls1, bp1: @report.bp1, bp: @report.bp, bskey1: @report.bskey1, btkey: @report.btkey, btn1: @report.btn1, bts1: @report.bts1, bts: @report.bts, chkey1: @report.chkey1, chkey: @report.chkey, ckey1: @report.ckey1, ckey: @report.ckey, ekey1: @report.ekey1, ekey: @report.ekey, fkey1: @report.fkey1, fkey: @report.fkey, fq: @report.fq, fxb: @report.fxb, group1: @report.group1, group2: @report.group2, inn1: @report.inn1, inn: @report.inn, lk1: @report.lk1, lnk1: @report.lnk1, lxb: @report.lxb, lxm: @report.lxm, metric: @report.metric, mkey1: @report.mkey1, mkey: @report.mkey, mtkey1: @report.mtkey1, mtkey: @report.mtkey, pckey1: @report.pckey1, pckey: @report.pckey, ptname1: @report.ptname1, ptname: @report.ptname, reportname: @report.reportname, sd: @report.sd, spkey1: @report.spkey1, st: @report.st, tkey1: @report.tkey1, tkey: @report.tkey, tmkey1: @report.tmkey1, tmkey: @report.tmkey, ttkey1: @report.ttkey1, ttkey: @report.ttkey, vid: @report.vid, vkey1: @report.vkey1, vkey: @report.vkey }
    assert_redirected_to report_path(assigns(:report))
  end

  test "should destroy report" do
    assert_difference('Report.count', -1) do
      delete :destroy, id: @report
    end

    assert_redirected_to reports_path
  end
end
