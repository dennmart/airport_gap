class AirportsController < ApplicationController
  def index
    @airports = Airport.all.page(params[:page]).per_page(100)
  end
end
