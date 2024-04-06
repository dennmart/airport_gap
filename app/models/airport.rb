class Airport < ApplicationRecord
  has_many :favorites, dependent: :destroy

  validates :name, :iata, presence: true

  def self.distance_between(first_airport, second_airport)
    unless first_airport.is_a?(Airport) && second_airport.is_a?(Airport)
      raise ArgumentError,
            'expected two Airport records'
    end

    c1 = [first_airport.latitude, first_airport.longitude]
    c2 = [second_airport.latitude, second_airport.longitude]
    haversine = Haversine.distance(c1, c2)

    OpenStruct.new(
      from_airport: first_airport,
      to_airport: second_airport,
      kilometers: haversine.to_km,
      miles: haversine.to_miles,
      nautical_miles: haversine.to_nautical_miles
    )
  end
end
