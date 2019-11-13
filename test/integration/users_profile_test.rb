require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
    @user = users(:michael)
  end

  test "profile display" do
    get user_path(@user)
    assert_template 'users/show'
    assert_select 'title', full_title(@user.name)
    assert_select 'h1', text: @user.name
    assert_select 'h1>img.gravatar'
    assert_match @user.microposts.count.to_s, response.body
    assert_select 'div.pagination',count:1
    
    
    @user.microposts.paginate(page: 1).each do |micropost|
      assert_match micropost.content, response.body
    end
    assert_match @user.active_relationships.count.to_s, response.body
    assert_match @user.passive_relationships.count.to_s, response.body
  end
  
  test "microposts search" do
    # All microposts
    get user_path(@user), params: {q: {content_cont: ""}}
    @user.microposts.paginate(page: 1).each do |micropost|
      assert_match micropost.content, response.body
    end
  
    # micropost search
    get user_path(@user), params: {q: {content_cont: "Sad"}}
    q = @user.microposts.ransack(content_cont: "Sad")
    q.result.paginate(page:1).each do |micropost|
      assert_match micropost.content, response.body
    end

    # micropost search
    get user_path(@user), params: {q: {content_cont: "aaaaaaaaaaaaaaaa"}}
    q = @user.microposts.ransack(content_cont: "aaaaaaaaaaaaaaaa")
    assert q.result.paginate(page:1).empty?
  end
  
end
