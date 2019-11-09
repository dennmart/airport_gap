class AirportsController < ApplicationController
  def index
    @airports = Airport.all
    render json: @airports
  end

  def show
    @airport = Airport.find_by(iata: params[:id])
    render json: @airport
  end
end
