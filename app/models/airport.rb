class Airport < ApplicationRecord
  validates :name, :iata, presence: true

  def self.distance_between(airport_1, airport_2)
    raise ArgumentError, "expected two Airport records" unless airport_1.is_a?(Airport) && airport_2.is_a?(Airport)

    c1 = [airport_1.latitude, airport_1.longitude]
    c2 = [airport_2.latitude, airport_2.longitude]
    haversine = Haversine.distance(c1, c2)

    {
      airport_1: airport_1.iata,
      airport_2: airport_2.iata,
      kilometers: haversine.to_km,
      miles: haversine.to_miles,
      nautical_miles: haversine.to_nautical_miles
    }
  end
end
