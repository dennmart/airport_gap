class PasswordResetsController < ApplicationController
  def new; end

  def create
    @user = User.find_by(email: params[:email])

    if @user
      @user.trigger_password_reset!
      redirect_to new_password_reset_path, notice: 'An email was sent with instructions for resetting your password.'
    else
      redirect_to new_password_reset_path,
                  alert: 'The email address you entered could not be found. Please check and try again.'
    end
  end

  def edit
    @user = User.find_by!(password_reset_token: params[:password_reset_token])

    return unless @user.password_reset_sent_at < 2.hours.ago

    redirect_to new_password_reset_path,
                alert: 'Your password reset link has expired. Please enter your email to send a new link.' and return
  end

  def update
    @user = User.find_by!(password_reset_token: params[:password_reset_token])

    if @user.password_reset_sent_at < 2.hours.ago
      redirect_to new_password_reset_path,
                  alert: 'Your password reset link has expired. Please enter your email address to send a new link.'
    elsif @user.update(user_params)
      @user.password_reset_successful!
      redirect_to login_path, notice: 'Your password was reset successfully. You can now log in with your new password.'
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
