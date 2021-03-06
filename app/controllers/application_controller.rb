class ApplicationController < ActionController::Base
  private

  def authorize
    redirect_to new_tokens_path if current_user.nil?
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user

  def authenticate_token
    authenticate_with_http_token do |token, options|
      @authenticated_user = User.find_by(token: token)
    end

    unless @authenticated_user.present?
      error = {
        errors: [{
          status: "401",
          title: "Unauthorized",
          detail: "You are not authorized to perform the requested action."
        }]
      }

      render json: error, status: :unauthorized
    end
  end
end
