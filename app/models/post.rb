class Post < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  validates :title, presence: true
  validates :caption, presence: true

  has_many :comments, dependent: :destroy
  has_many :votes, dependent: :destroy

  def vote_count
    votes.sum(:value)
  end

  def user_vote(user)
    votes.find_by(user_id: user.id)
  end
end
