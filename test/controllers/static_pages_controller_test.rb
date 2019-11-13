require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  
  def setup
    @base_title = "We Love Tennis"
  end
  
  test "should get home" do
    get root_url
    assert_response :success
    assert_select "title", "#{@base_title}"
  end

  test "should get help" do
    get help_path
    assert_response :success
    assert_select "title", "Help | #{@base_title}"
  end

  test "should get about" do
    get about_path
    assert_response :success
    assert_select "title", "このサイトについて | #{@base_title}"
  end
  
  test "should get contact" do
    get contact_path
    assert_response :success
    assert_select "title", "お問い合わせ | #{@base_title}"
  end

  test "should get link" do
    get link_path
    assert_response :success
    assert_select "title", "おすすめサイト | #{@base_title}"
  end


end
