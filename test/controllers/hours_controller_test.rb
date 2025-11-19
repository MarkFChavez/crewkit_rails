require "test_helper"

class HoursControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get hours_index_url
    assert_response :success
  end

  test "should get update" do
    get hours_update_url
    assert_response :success
  end
end
