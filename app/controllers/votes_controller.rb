class VotesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post
  def create
    @vote = @post.votes.find_or_initialize_by(user_id: current_user.id)
    vote_value = params[:value].to_i

    unless [ -1, 0, 1 ].include?(vote_value)
      redirect_back fallback_location: root_path, alert: "Invalid vote value"
      return
    end

    current_value = @vote.persisted? ? @vote.value : 0
    new_value =
      if vote_value == 0
        0
      elsif current_value == vote_value
        0
      else
        current_value + vote_value
      end

    if new_value == 0
      @vote.destroy if @vote.persisted?
      message = "vote removed"
    else
      @vote.value = new_value
      if @vote.save
        message = new_value == 1 ? "Upvoted!" : "Downvoted!"
      else
        message = "Error: #{@vote.errors.full_messages.join(", ")}"
      end
    end
    respond_to do |format|
      format.turbo_stream { render :create }
      format.html { redirect_back fallback_location: root_path, notice: message }
    end
  end

  def destroy
  end

  private

  def set_post
    @post = Post.find(params[ :post_id ]) # rubocop:disable Layout/SpaceInsideReferenceBrackets
  end
end
