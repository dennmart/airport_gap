require 'rails_helper'

RSpec.describe AirportDistance do
  let(:airport_from) { build(:airport) }
  let(:airport_to) { build(:airport) }

  describe '#initialize' do
    it "raises an ArgumentError if both arguments aren't an Airport record" do
      expect {
        AirportDistance.new(airport_from, [])
      }.to raise_error(ArgumentError)

      expect {
        AirportDistance.new([], airport_to)
      }.to raise_error(ArgumentError)
    end
  end

  describe '#call' do
    it 'returns a Struct with the distance between airports in kilometers, miles, and nautical miles' do
      distances = AirportDistance.new(airport_from, airport_to).call

      expect(distances).to be_a(Struct)
      expect(distances.from_airport).to eq(airport_from)
      expect(distances.to_airport).to eq(airport_to)
      expect(distances.kilometers).to be_a(Float)
      expect(distances.miles).to be_a(Float)
      expect(distances.nautical_miles).to be_a(Float)
    end
  end
end
