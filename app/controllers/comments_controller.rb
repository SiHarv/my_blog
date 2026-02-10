class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post
  before_action :set_comment, only: [ :destroy ]
  before_action :authorize_destroy!, only: [ :destroy ]
  def create
    @comment = @post.comments.build(comment_params.merge(user: current_user))
    if @comment.save
      redirect_back fallback_location: root_path, notice: "Comment was successfully created."
    else
      redirect_back fallback_location: root_path, alert: @comment.errors.full_messages.to_sentence
    end
  end

  def destroy
    @comment.destroy
    redirect_back fallback_location: root_path, notice: "Comment was successfully deleted."
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def set_comment
    @comment = @post.comments.find(params[:id])
  end

  def authorize_destroy!
    return if current_user == @comment.user || current_user == @post.user
    head :fobidden
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
