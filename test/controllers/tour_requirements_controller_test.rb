require "test_helper"

class TourRequirementsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get tour_requirements_new_url
    assert_response :success
  end

  test "should get create" do
    get tour_requirements_create_url
    assert_response :success
  end

  test "should get update" do
    get tour_requirements_update_url
    assert_response :success
  end

  test "should get edit" do
    get tour_requirements_edit_url
    assert_response :success
  end

  test "should get show" do
    get tour_requirements_show_url
    assert_response :success
  end
end
