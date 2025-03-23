class TokensController < ApplicationController
  before_action :authorize, only: [:show, :regenerate]

  def show; end

  def new
    @user = User.new
  end

  def create
    return render_invalid_captcha unless valid_captcha?

    @user = User.new(user_params)

    if @user.save
      session[:user_id] = @user.id

      if ActiveModel::Type::Boolean.new.cast(ENV.fetch('SEND_GENERATED_TOKEN_EMAIL', nil))
        UserMailer.generated_token(@user.id).deliver_later
      end

      redirect_to tokens_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def regenerate
    current_user.regenerate_token
    redirect_to tokens_path, notice: 'Your authentication token has been regenerated!'
  end

  private

  def valid_captcha?
    CaptchaVerify.new(params['cf-turnstile-response']).call
  end

  def render_invalid_captcha
    @user = User.new(user_params)
    flash.now[:alert] = 'Could not validate captcha'
    render :new, status: :unprocessable_entity
  end

  def user_params
    params.expect(user: [:email, :password])
  end
end
