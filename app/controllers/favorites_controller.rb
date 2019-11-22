class FavoritesController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_token

  def index
    @favorites = @authenticated_user.favorites.page(params[:page])

    if @favorites.present?
      options = {
        links: {
          first: favorites_url,
          self: favorites_url(page: params[:page]),
          last: favorites_url(page: @favorites.total_pages)
        }
      }
      render json: FavoriteSerializer.new(@favorites, options).serialized_json
    else
      # TODO: Implement a better error message
      head :not_found
    end
  end

  def show
    @favorite = @authenticated_user.favorites.find(params[:id])
    render json: FavoriteSerializer.new(@favorite).serialized_json
  rescue ActiveRecord::RecordNotFound
    # TODO: Implement a better error message
    head :not_found
  end

  def create
    @airport = Airport.find_by(iata: params[:airport_id])
    @favorite = @authenticated_user.favorites.new(airport: @airport, note: params[:note])

    if @favorite.save
      render json: FavoriteSerializer.new(@favorite).serialized_json
    else
      # TODO: Implement a better error message
      head :unprocessable_entity
    end
  end

  def update
    @favorite = @authenticated_user.favorites.find(params[:id])

    if @favorite.update(note: params[:note])
      render json: FavoriteSerializer.new(@favorite).serialized_json
    else
      # TODO: Implement a better error message
      head :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    # TODO: Implement a better error message
    head :not_found
  end

  def destroy
    @favorite = @authenticated_user.favorites.find(params[:id])
    @favorite.destroy
    head :no_content
  rescue ActiveRecord::RecordNotFound
    # TODO: Implement a better error message
    head :not_found
  end
end
