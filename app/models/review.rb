class Review < ApplicationRecord
  belongs_to :shop

  validates :score, presence: true, inclusion: { in: 1..5, message: "は1から5の間で入力してください" }
  validates :comments, presence: true, length: { maximum: 1000 }
end
