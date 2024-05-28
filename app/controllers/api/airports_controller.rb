module Api
  class AirportsController < ApiController
    def index
      @airports = Airport.all.page(params[:page])
      render json: AirportSerializer.new(@airports, generate_links_metadata(@airports)).serializable_hash.to_json
    end

    def show
      @airport = Airport.find_by(iata: params[:id])

      if @airport
        render json: AirportSerializer.new(@airport).serializable_hash.to_json
      else
        render json: not_found_error_response, status: :not_found
      end
    end

    def distance
      airport_from = Airport.find_by(iata: params[:from])
      airport_to = Airport.find_by(iata: params[:to])

      if airport_from && airport_to
        distances = AirportDistance.new(airport_from, airport_to).call
        render json: AirportDistanceSerializer.new(distances).serializable_hash.to_json
      else
        error_message = "Please enter valid 'from' and 'to' airports."
        render json: unprocessable_entity_response(error_message), status: :unprocessable_entity
      end
    end
  end
end
