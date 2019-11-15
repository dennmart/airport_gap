require 'rails_helper'

RSpec.describe Airport, type: :model do
  describe "associations" do
    it { should have_many(:favorites) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:iata) }
  end

  describe ".distance_between" do
    let(:airport_1) { build(:airport) }
    let(:airport_2) { build(:airport) }

    it "raises an ArgumentError if both arguments aren't an Airport record" do
      expect {
        Airport.distance_between(airport_1, [])
      }.to raise_error(ArgumentError)

      expect {
        Airport.distance_between([], airport_2)
      }.to raise_error(ArgumentError)
    end

    it "returns an OpenStruct object with the distance between airports in kilometers, miles, and nautical miles" do
      distances = Airport.distance_between(airport_1, airport_2)

      expect(distances).to be_an(OpenStruct)
      expect(distances.from_airport).to eq(airport_1)
      expect(distances.to_airport).to eq(airport_2)
      expect(distances.kilometers).to be_a(Float)
      expect(distances.miles).to be_a(Float)
      expect(distances.nautical_miles).to be_a(Float)
    end
  end
end
