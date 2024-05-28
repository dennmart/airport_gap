class AirportDistanceSerializer
  include JSONAPI::Serializer

  set_id { |record| "#{record.from_airport.iata}-#{record.to_airport.iata}" }
  attributes :from_airport, :to_airport, :kilometers, :miles, :nautical_miles
  cache_options store: Rails.cache, namespace: 'jsonapi-serializer'
end
