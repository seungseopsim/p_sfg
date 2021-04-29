require 'test_helper'

class ReportroomsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @reportroom = reportrooms(:one)
  end

  test "should get index" do
    get reportrooms_url
    assert_response :success
  end

  test "should get new" do
    get new_reportroom_url
    assert_response :success
  end

  test "should create reportroom" do
    assert_difference('Reportroom.count') do
      post reportrooms_url, params: { reportroom: { contents: @reportroom.contents, plancontents: @reportroom.plancontents, roomtype: @reportroom.roomtype } }
    end

    assert_redirected_to reportroom_url(Reportroom.last)
  end

  test "should show reportroom" do
    get reportroom_url(@reportroom)
    assert_response :success
  end

  test "should get edit" do
    get edit_reportroom_url(@reportroom)
    assert_response :success
  end

  test "should update reportroom" do
    patch reportroom_url(@reportroom), params: { reportroom: { contents: @reportroom.contents, plancontents: @reportroom.plancontents, roomtype: @reportroom.roomtype } }
    assert_redirected_to reportroom_url(@reportroom)
  end

  test "should destroy reportroom" do
    assert_difference('Reportroom.count', -1) do
      delete reportroom_url(@reportroom)
    end

    assert_redirected_to reportrooms_url
  end
end
