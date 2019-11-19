class ApplicationController < ActionController::Base
  private

  def authenticate_token
    authenticate_with_http_token do |token, options|
      @current_user = User.find_by(token: token)
    end

    unless @current_user.present?
      # TODO: Implement a better error message
      head :unauthorized and return
    end
  end
end
