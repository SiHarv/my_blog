class VotesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post
  def create
    @vote = @post.votes.find_or_initialize_by(user_id: current_user.id)
    vote_value = params[:value].to_i
    if vote_value == 0
      @vote.destroy if @vote.persisted?
      message = "vote removed"
    else
      @vote.value = vote_value
      if @vote.save
        message = vote_value == 1 ? "Upvoted!" : "Downvoted!"
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
