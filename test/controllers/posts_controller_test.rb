require "test_helper"

class PostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @post = Post.create(title: "Test Post", caption: "Test Caption", user: @user)
  end

  test "should redirect to sign_in for new without authentication" do
    get new_post_url
    assert_response :redirect
    assert_redirected_to new_user_session_url
  end

  test "should get new when authenticated" do
    login_as @user
    get new_post_url
    assert_response :success
  end

  test "should create post when authenticated" do
    login_as @user
    post posts_url, params: { post: { title: "New Post", caption: "New Caption" } }
    assert_response :redirect
    assert_redirected_to root_url
  end

  test "should get index" do
    get posts_url
    assert_response :success
  end

  test "should show post" do
    get post_url(@post)
    assert_response :success
  end

  test "should redirect to sign_in for edit without authentication" do
    get edit_post_url(@post)
    assert_response :redirect
    assert_redirected_to new_user_session_url
  end

  test "should get edit when authenticated and authorized" do
    login_as @user
    get edit_post_url(@post)
    assert_response :success
  end

  test "should update post when authenticated and authorized" do
    login_as @user
    patch post_url(@post), params: { post: { title: "Updated", caption: "Updated Caption" } }
    assert_response :redirect
    assert_redirected_to root_url
    @post.reload
    assert_equal "Updated", @post.title
  end

  test "should destroy post when authenticated and authorized" do
    login_as @user
    delete post_url(@post)
    assert_response :redirect
    assert_redirected_to root_url
    assert_not Post.exists?(@post.id)
  end
end
