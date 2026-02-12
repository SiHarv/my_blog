class Vote < ApplicationRecord
  belongs_to :post
  belongs_to :user

  validates :value, presence: true, inclusion: { in: [ -1, 1 ] }
  validates :user_id, uniqueness: { scope: :post_id, message: "can only vote once per post" }
end
