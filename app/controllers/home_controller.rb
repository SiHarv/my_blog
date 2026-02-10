class HomeController < ApplicationController
  def index
    @posts = Post.includes(:user, comments: :user).order(created_at: :desc)
    @post = current_user.present? ? current_user.posts.build : Post.new
  end
end
