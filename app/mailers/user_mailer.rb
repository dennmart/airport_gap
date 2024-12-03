class UserMailer < ApplicationMailer
  def generated_token(user_id)
    @user = User.find(user_id)
    mail(to: @user.email, subject: "Here's your generated token")
  end

  def password_reset_instructions(user_id, password_reset_token)
    @user = User.find(user_id)
    @password_reset_token = password_reset_token
    mail(to: @user.email, subject: 'Password reset instructions')
  end

  def password_change_notification(user_id)
    @user = User.find(user_id)
    mail(to: @user.email, subject: 'Your password has been reset')
  end
end
