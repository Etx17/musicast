require "test_helper"

class PianistAccompagnateursControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get pianist_accompagnateurs_new_url
    assert_response :success
  end

  test "should get create" do
    get pianist_accompagnateurs_create_url
    assert_response :success
  end

  test "should get edit" do
    get pianist_accompagnateurs_edit_url
    assert_response :success
  end

  test "should get update" do
    get pianist_accompagnateurs_update_url
    assert_response :success
  end

  test "should get delete" do
    get pianist_accompagnateurs_delete_url
    assert_response :success
  end
end
