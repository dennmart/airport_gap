class PasswordResetsController < ApplicationController
  def new; end

  def edit
    @user = User.find_by_password_reset_token(params[:password_reset_token])

    return if @user.present?

    message = 'Your password reset link is invalid or has expired. Please enter your email address to send a new link.'
    redirect_to new_password_reset_path, alert: message
  end

  def create
    @user = User.find_by(email: params[:email])

    UserMailer.password_reset_instructions(@user.id, @user.password_reset_token).deliver_now if @user.present?

    redirect_to new_password_reset_path,
                notice: 'We sent an email with instructions for resetting your password if your account was found.'
  end

  def update
    @user = User.find_by_password_reset_token(params[:password_reset_token])

    if @user.present? && @user.update(user_params)
      UserMailer.password_change_notification(@user.id).deliver_later
      redirect_to login_path, notice: 'Your password was reset successfully. You can now log in with your new password.'
    elsif @user.present?
      render :edit, status: :unprocessable_entity
    else
      message = 'Your password reset link is invalid or expired. Please enter your email address to send a new link.'
      redirect_to new_password_reset_path, alert: message
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
