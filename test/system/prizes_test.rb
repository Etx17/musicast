require "application_system_test_case"

class PrizesTest < ApplicationSystemTestCase
  setup do
    @prize = prizes(:one)
  end

  test "visiting the index" do
    visit prizes_url
    assert_selector "h1", text: "Prizes"
  end

  test "should create prize" do
    visit prizes_url
    click_on "New prize"

    fill_in "Amount", with: @prize.amount
    fill_in "Category", with: @prize.category_id
    fill_in "Description", with: @prize.description
    fill_in "Title", with: @prize.title
    click_on "Create Prize"

    assert_text "Prize was successfully created"
    click_on "Back"
  end

  test "should update Prize" do
    visit prize_url(@prize)
    click_on "Edit this prize", match: :first

    fill_in "Amount", with: @prize.amount
    fill_in "Category", with: @prize.category_id
    fill_in "Description", with: @prize.description
    fill_in "Title", with: @prize.title
    click_on "Update Prize"

    assert_text "Prize was successfully updated"
    click_on "Back"
  end

  test "should destroy Prize" do
    visit prize_url(@prize)
    click_on "Destroy this prize", match: :first

    assert_text "Prize was successfully destroyed"
  end
end
