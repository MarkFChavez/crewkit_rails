require "test_helper"

class AttendanceControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get attendance_index_url
    assert_response :success
  end

  test "should get quick_entry" do
    get attendance_quick_entry_url
    assert_response :success
  end

  test "should get update" do
    get attendance_update_url
    assert_response :success
  end
end
