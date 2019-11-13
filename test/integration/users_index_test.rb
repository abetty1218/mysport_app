require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest

  def setup
    @admin     = users(:michael)
    @non_admin = users(:archer)
    @non_activated_user = users(:non_activated)
  end

  test "index as admin including pagination and delete links" do
    log_in_as(@admin)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination'
    first_page_of_users = User.paginate(page: 1)
    first_page_of_users.each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
      unless user == @admin
        assert_select 'a[href=?]', user_path(user), text: '削除'
      end
    end
    assert_difference 'User.count', -1 do
      delete user_path(@non_admin)
    end
  end

  test "index as non-admin" do
    log_in_as(@non_admin)
    get users_path
    assert_select 'a', text: 'delete', count: 0
  end
  
  test "should not allow the not activated attribute" do
    log_in_as(@non_activated_user)
    assert_not @non_activated_user.activated?
    get users_path
    assert_select "a[href=?]", user_path(@non_activated_user), count: 0
    get user_path(@non_activated_user)
    assert_redirected_to root_url
  end
  
  test "users search" do
    log_in_as(@admin)
    # All users
    get users_path, params: {q: {name_cont: ""}}
    User.paginate(page:1).each do |user|
       assert_select 'a[href=?]', user_path(user), text:user.name
    end
    
    # User search
    get users_path, params: {q: {name_cont: "a"}}
    q = User.ransack(name_cont: "a", activated_true: true)
    q.result.paginate(page:1).each do |user|
      assert_select 'a[href=?]', user_path(user), text:user.name
    end
    
    # User search
    get users_path, params: {q: {name_cont: "aaaaaaaaaaaaaaaaaaaaa"}}
    q = User.ransack(name_cont: "aaaaaaaaaaaaaaaaaaaaa", activated_true: true)
    assert q.result.paginate(page:1).empty?
  end
  
  
  
  
end