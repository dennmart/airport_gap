class User < ApplicationRecord
  has_secure_token
  # Rails 8.0 uses the `password_reset_token` attribute, which had been set up previously
  # on this application. I'll disable it for now until I update the code to use it.
  has_secure_password reset_token: false
  has_many :favorites, dependent: :destroy

  validates :email, presence: true, uniqueness: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }

  def trigger_password_reset!
    update(password_reset_token: SecureRandom.urlsafe_base64, password_reset_sent_at: Time.current)
    UserMailer.password_reset_instructions(id).deliver_later
  end

  def password_reset_successful!
    update(password_reset_token: nil, password_reset_sent_at: nil)
    UserMailer.password_change_notification(id).deliver_later
  end
end
