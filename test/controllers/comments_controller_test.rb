require "test_helper"

class CommentsControllerTest < ActionDispatch::IntegrationTest
  test "should create comment" do
    user = users(:one)
    post = posts(:one)

    login_as(user, scope: :user)

    assert_difference("Comment.count", 1) do
      post post_comments_url(post), params: { comment: { body: "Test comment" } }
    end

    assert_redirected_to root_path
  end

  test "should destroy comment" do
    user = users(:one)
    post = posts(:one)
    comment = comments(:one)

    login_as(user, scope: :user)

    assert_difference("Comment.count", -1) do
      delete post_comment_url(post, comment)
    end

    assert_redirected_to root_path
  end
end
