class AirportSerializer
  include JSONAPI::Serializer

  set_id :iata
  attributes :name, :city, :country, :iata, :icao, :latitude, :longitude, :altitude, :timezone
  cache_options store: Rails.cache, namespace: 'jsonapi-serializer'
end
