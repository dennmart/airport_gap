class AirportDistanceSerializer
  include FastJsonapi::ObjectSerializer
  set_id { |record| "#{record.from_airport.iata}-#{record.to_airport.iata}" }
  attributes :from_airport, :to_airport, :kilometers, :miles, :nautical_miles
end
