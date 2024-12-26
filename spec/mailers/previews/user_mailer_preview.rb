# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  def generated_token
    user = User.last
    UserMailer.generated_token(user.id)
  end

  def password_reset_instructions
    user = User.last
    UserMailer.password_reset_instructions(user.id, user.password_reset_token)
  end

  def password_change_notification
    user = User.last
    UserMailer.password_change_notification(user.id)
  end
end
