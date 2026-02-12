require "test_helper"

class VotesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post

  def create
    @vote = @post.votes.find_or_initialize_by(user_id: current_user.id)
    
    vote_value = params[:value].to_i
    
    if vote_value == 0
      @vote.destroy if @vote.persisted?
      message = "Vote removed"
    else
      @vote.value = vote_value
      if @vote.save
        message = vote_value == 1 ? "Upvoted!" : "Downvoted!"
      else
        # Log errors for debugging
        Rails.logger.error "Vote save failed: #{@vote.errors.full_messages.join(', ')}"
        message = "Error: #{@vote.errors.full_messages.join(', ')}"
      end
    end

    redirect_back fallback_location: root_path, notice: message
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end
end
