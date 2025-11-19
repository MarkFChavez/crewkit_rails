require "test_helper"

class ExportControllerTest < ActionDispatch::IntegrationTest
  test "should get attendance" do
    get export_attendance_url
    assert_response :success
  end

  test "should get hours" do
    get export_hours_url
    assert_response :success
  end
end
