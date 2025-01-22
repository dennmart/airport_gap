class TokensController < ApplicationController
  before_action :authorize, only: [:show, :regenerate]

  def show; end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      session[:user_id] = @user.id
      UserMailer.generated_token(@user.id).deliver_later
      redirect_to tokens_path
    else
      render :new
    end
  end

  def regenerate
    current_user.regenerate_token
    redirect_to tokens_path, notice: 'Your authentication token has been regenerated!'
  end

  private

  def user_params
    params.expect(user: [:email, :password])
  end
end
