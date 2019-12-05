class Api::TokensController < ApiController
  def create
    user = User.find_by(email: params[:email])

    if user && user.authenticate(params[:password])
      render json: { token: user.token }, status: :ok
    else
      # TODO: Refactor this response to a common location with the rest of the API.
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
