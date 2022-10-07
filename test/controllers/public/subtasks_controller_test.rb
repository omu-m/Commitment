require "test_helper"

class Public::SubtasksControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get public_subtasks_index_url
    assert_response :success
  end

  test "should get show" do
    get public_subtasks_show_url
    assert_response :success
  end

  test "should get edit" do
    get public_subtasks_edit_url
    assert_response :success
  end
end
