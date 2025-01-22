class SessionsController < ApplicationController
  def new; end

  def create
    @user = User.find_by(email: user_params[:email])

    if @user&.authenticate(user_params[:password])
      session[:user_id] = @user.id
      redirect_to tokens_path
    else
      redirect_to login_path, alert: 'Your email and/or password is invalid. Please check and try again.'
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_path, notice: 'You have been logged out of Airport Gap.'
  end

  private

  def user_params
    params.expect(user: [:email, :password])
  end
end
