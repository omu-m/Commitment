require "test_helper"

class Admin::SubtasksControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_subtasks_index_url
    assert_response :success
  end

  test "should get show" do
    get admin_subtasks_show_url
    assert_response :success
  end

  test "should get edit" do
    get admin_subtasks_edit_url
    assert_response :success
  end
end
