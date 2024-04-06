module Api
  class AirportsController < ApiController
    def index
      @airports = Airport.all.page(params[:page])

      options = if @airports.present?
                  {
                    links: {
                      first: api_airports_url,
                      self: api_airports_url(page: params[:page]),
                      last: api_airports_url(page: @airports.total_pages),
                      prev: api_airports_url(page: @airports.previous_page),
                      next: api_airports_url(page: @airports.next_page)
                    }
                  }
                else
                  {}
                end

      render json: AirportSerializer.new(@airports, options).serialized_json
    end

    def show
      @airport = Airport.find_by(iata: params[:id])

      if @airport
        render json: AirportSerializer.new(@airport).serialized_json
      else
        render json: not_found_error_response, status: :not_found
      end
    end

    def distance
      airport_from = Airport.find_by(iata: params[:from])
      airport_to = Airport.find_by(iata: params[:to])

      if airport_from && airport_to
        distances = Airport.distance_between(airport_from, airport_from)
        render json: AirportDistanceSerializer.new(distances).serialized_json
      else
        error_message = "Please enter valid 'from' and 'to' airports."
        render json: unprocessable_entity_response(error_message), status: :unprocessable_entity
      end
    end
  end
end
