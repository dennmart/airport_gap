module Api
  class TokensController < ApiController
    def create
      user = User.find_by(email: params[:email])

      if user&.authenticate(params[:password])
        render json: { token: user.token }, status: :ok
      else
        render json: {
          errors: [{
            status: '401',
            title: 'Unauthorized',
            detail: 'You are not authorized to perform the requested action.'
          }]
        }, status: :unauthorized
      end
    end
  end
end
