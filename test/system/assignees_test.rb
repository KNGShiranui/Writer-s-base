require "application_system_test_case"

class AssigneesTest < ApplicationSystemTestCase
  setup do
    @assignee = assignees(:one)
  end

  test "visiting the index" do
    visit assignees_url
    assert_selector "h1", text: "Assignees"
  end

  test "creating a Assignee" do
    visit assignees_url
    click_on "New Assignee"

    fill_in "Issue", with: @assignee.issue_id
    fill_in "User", with: @assignee.user_id
    click_on "Create Assignee"

    assert_text "Assignee was successfully created"
    click_on "Back"
  end

  test "updating a Assignee" do
    visit assignees_url
    click_on "Edit", match: :first

    fill_in "Issue", with: @assignee.issue_id
    fill_in "User", with: @assignee.user_id
    click_on "Update Assignee"

    assert_text "Assignee was successfully updated"
    click_on "Back"
  end

  test "destroying a Assignee" do
    visit assignees_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Assignee was successfully destroyed"
  end
end
