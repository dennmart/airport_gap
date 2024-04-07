class AirportDistance
  def initialize(airport_from, airport_to)
    raise ArgumentError, 'expected two Airport records' unless airport_from.is_a?(Airport) && airport_to.is_a?(Airport)

    @airport_from = airport_from
    @airport_to = airport_to
  end

  def call
    c1 = [@airport_from.latitude, @airport_from.longitude]
    c2 = [@airport_to.latitude, @airport_to.longitude]
    haversine = Haversine.distance(c1, c2)

    distance_struct = Struct.new(:from_airport, :to_airport, :kilometers, :miles, :nautical_miles)

    distance_struct.new(
      from_airport: @airport_from,
      to_airport: @airport_to,
      kilometers: haversine.to_km,
      miles: haversine.to_miles,
      nautical_miles: haversine.to_nautical_miles
    )
  end
end
