class AirportsController < ApplicationController
  def index
    @airports = Airport.all
    render json: AirportSerializer.new(@airports).serialized_json
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
end
