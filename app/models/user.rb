class User < ApplicationRecord
  has_secure_token
  has_secure_password
  has_many :favorites, dependent: :destroy

  validates :email, presence: true, uniqueness: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
end
