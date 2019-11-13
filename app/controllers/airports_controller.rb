class AirportsController < ApplicationController
  def index
    @airports = Airport.all.page(params[:page])

    if @airports.present?
      options = {
        links: {
          first: airports_url,
          self: airports_url(page: params[:page]),
          last: airports_url(page: @airports.total_pages)
        }
      }
      render json: AirportSerializer.new(@airports, options).serialized_json
    else
      # TODO: Implement a better error message
      head :not_found
    end
  end

  def show
    @airport = Airport.find_by(iata: params[:id])

    if @airport
      render json: AirportSerializer.new(@airport).serialized_json
    else
      # TODO: Implement a better error message
      head :not_found
    end
  end

  private
end
