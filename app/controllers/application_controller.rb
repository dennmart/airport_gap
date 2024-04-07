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
    authenticate_with_http_token do |token, _options|
      @authenticated_user = User.find_by(token: token)
    end

    return if @authenticated_user.present?

    render json: { errors: [{
      status: '401',
      title: 'Unauthorized',
      detail: 'You are not authorized to perform the requested action.'
    }] }, status: :unauthorized
  end

  def generate_links_metadata(resource)
    if resource.present?
      {
        links: {
          first: api_airports_url,
          self: api_airports_url(page: params[:page]),
          last: api_airports_url(page: resource.total_pages),
          prev: api_airports_url(page: resource.previous_page),
          next: api_airports_url(page: resource.next_page)
        }
      }
    else
      {}
    end
  end
end
