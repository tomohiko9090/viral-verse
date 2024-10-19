class User < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to_active_hash :language

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }, if: -> { new_record? || changes[:password_digest] }
  validates :role, presence: true
  validates :language_id, presence: true

  has_secure_password

  enum role: {
    admin: 1,
    owner: 2
    # customer: 3
  }
end
