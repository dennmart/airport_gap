module Api
  class FavoritesController < ApiController
    before_action :authenticate_token

    def index
      @favorites = @authenticated_user.favorites.page(params[:page])

      options = if @favorites.present?
                  {
                    links: {
                      first: api_favorites_url,
                      self: api_favorites_url(page: params[:page]),
                      last: api_favorites_url(page: @favorites.total_pages),
                      prev: api_favorites_url(page: @favorites.previous_page),
                      next: api_favorites_url(page: @favorites.next_page)
                    }
                  }
                else
                  {}
                end

      render json: FavoriteSerializer.new(@favorites, options).serialized_json
    end

    def show
      @favorite = @authenticated_user.favorites.find(params[:id])
      render json: FavoriteSerializer.new(@favorite).serialized_json
    rescue ActiveRecord::RecordNotFound
      render json: not_found_error_response, status: :not_found
    end

    def create
      @airport = Airport.find_by(iata: params[:airport_id])
      @favorite = @authenticated_user.favorites.new(airport: @airport, note: params[:note])

      if @favorite.save
        render json: FavoriteSerializer.new(@favorite).serialized_json, status: :created
      else
        # TODO: Improve how we display this error.
        error_message = @favorite.errors.values.flatten.first
        render json: unprocessable_entity_response(error_message), status: :unprocessable_entity
      end
    end

    def update
      @favorite = @authenticated_user.favorites.find(params[:id])

      if @favorite.update(note: params[:note])
        render json: FavoriteSerializer.new(@favorite).serialized_json
      else
        error_message = 'Please enter a valid note.'
        render json: unprocessable_entity_response(error_message), status: :unprocessable_entity
      end
    rescue ActiveRecord::RecordNotFound
      render json: not_found_error_response, status: :not_found
    end

    def destroy
      @favorite = @authenticated_user.favorites.find(params[:id])
      @favorite.destroy
      head :no_content
    rescue ActiveRecord::RecordNotFound
      render json: not_found_error_response, status: :not_found
    end

    def clear_all
      @authenticated_user.favorites.destroy_all
      head :no_content
    end
  end
end
