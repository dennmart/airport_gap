class User < ApplicationRecord
  has_secure_token
  has_secure_password
  has_many :favorites

  validates :email, presence: true, uniqueness: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }

  def trigger_password_reset!
    update(password_reset_token: SecureRandom.urlsafe_base64, password_reset_sent_at: Time.current)
    # TODO: Send email
  end

  def password_reset_successful!
    update(password_reset_token: nil, password_reset_sent_at: nil)
    # TODO: Send email
  end
end
