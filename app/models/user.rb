class User < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions

  has_many :shop_users, dependent: :destroy
  has_many :shops, through: :shop_users

  belongs_to_active_hash :language

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }, if: -> { new_record? || changes[:password_digest] }
  validates :role, presence: true
  validates :language_id, presence: true

  has_secure_password

  enum role: {
    admin: 1, # システム管理者
    owner: 2, # 通常オーナー（1店舗のみ）
    # multipul_owner: 3, # 複数店舗オーナー（複数店舗）
    # customer: 4 # アンケート回答者
  }
end
