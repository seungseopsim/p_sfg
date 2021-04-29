require "application_system_test_case"

class ReportroomsTest < ApplicationSystemTestCase
  setup do
    @reportroom = reportrooms(:one)
  end

  test "visiting the index" do
    visit reportrooms_url
    assert_selector "h1", text: "Reportrooms"
  end

  test "creating a Reportroom" do
    visit reportrooms_url
    click_on "New Reportroom"

    fill_in "Contents", with: @reportroom.contents
    fill_in "Plancontents", with: @reportroom.plancontents
    fill_in "Roomtype", with: @reportroom.roomtype
    click_on "Create Reportroom"

    assert_text "Reportroom was successfully created"
    click_on "Back"
  end

  test "updating a Reportroom" do
    visit reportrooms_url
    click_on "Edit", match: :first

    fill_in "Contents", with: @reportroom.contents
    fill_in "Plancontents", with: @reportroom.plancontents
    fill_in "Roomtype", with: @reportroom.roomtype
    click_on "Update Reportroom"

    assert_text "Reportroom was successfully updated"
    click_on "Back"
  end

  test "destroying a Reportroom" do
    visit reportrooms_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Reportroom was successfully destroyed"
  end
end
