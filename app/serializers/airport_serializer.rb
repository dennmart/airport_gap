class AirportSerializer
  include FastJsonapi::ObjectSerializer
  set_id :iata
  attributes :name, :city, :country, :iata, :icao, :latitude, :longitude, :altitude, :timezone
end
