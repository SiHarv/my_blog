class Post < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  validates :title, presence: true
  validates :caption, presence: true

  has_many :comments, dependent: :destroy
end
