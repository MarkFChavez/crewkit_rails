require "test_helper"

class TeamMembersControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get team_members_new_url
    assert_response :success
  end

  test "should get create" do
    get team_members_create_url
    assert_response :success
  end

  test "should get edit" do
    get team_members_edit_url
    assert_response :success
  end

  test "should get update" do
    get team_members_update_url
    assert_response :success
  end

  test "should get destroy" do
    get team_members_destroy_url
    assert_response :success
  end
end
