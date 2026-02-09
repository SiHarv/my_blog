class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :authorize_user!, only: [:edit, :update, :destroy]
  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to root_path, notice: "Post was successfully created."
    else
      @posts = Post.includes(:user).order(created_at: :desc)
      render "home/index"
    end
  end

  def new
    @post = current_user.posts.build
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to root_path, notice: "Post was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @post.destroy
    redirect_to root_path, notice: "Post deleted succesfully."
  end

  def index
    @post = Post.includes(:user).order(created_at: :desc)
  end

  def show
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def authorize_user!
    redirect_to root_path, alert: "You are not authorized to perform this action." unless @post.user == current_user
  end

  def post_params
    params.require(:post).permit(:title, :caption)
  end
end
