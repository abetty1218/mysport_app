require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test "full title helper" do
    assert_equal full_title,         "We Love Tennis"
    assert_equal full_title("Help"), "Help | We Love Tennis"
  end
end