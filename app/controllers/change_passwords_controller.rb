class ChangePasswordsController < ApplicationController
  before_action :authorize

  def show; end

  def update
    unless current_user.authenticate(params[:current_password])
      redirect_to change_password_path,
                  alert: 'Your current password is invalid. Please check and try again.' and return
    end

    if current_user.update(change_password_params)
      redirect_to tokens_path, notice: 'Your password has been changed!'
    else
      render :show
    end
  end

  private

  def change_password_params
    params.expect(user: [:password, :password_confirmation])
  end
end
