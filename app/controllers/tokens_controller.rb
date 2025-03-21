class TokensController < ApplicationController
  before_action :authorize, only: [:show, :regenerate]

  def show; end

  def new
    @user = User.new
  end

  def create
    captcha_verify = CaptchaVerify.new(params['cf-turnstile-response']).call
    @user = User.new(user_params)

    if captcha_verify
      if @user.save
        session[:user_id] = @user.id
        UserMailer.generated_token(@user.id).deliver_later
        redirect_to tokens_path
      else
        render :new, status: :unprocessable_entity
      end
    else
      flash.now[:alert] = 'Could not validate captcha'
      render :new, status: :unprocessable_entity
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
