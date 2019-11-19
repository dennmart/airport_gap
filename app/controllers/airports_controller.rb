class AirportsController < ApplicationController
  skip_before_action :verify_authenticity_token

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

  def distance
    airport_1 = Airport.find_by(iata: params[:from])
    airport_2 = Airport.find_by(iata: params[:to])

    if airport_1 && airport_2
      distances = Airport.distance_between(airport_1, airport_2)
      render json: AirportDistanceSerializer.new(distances).serialized_json
    else
      # TODO: Implement a better error message
      head :unprocessable_entity
    end
  end
end
