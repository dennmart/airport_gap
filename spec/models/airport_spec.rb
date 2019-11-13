require 'rails_helper'

RSpec.describe Airport, type: :model do
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

    it "returns a hash with the distance between airports in kilometers, miles, and nautical miles" do
      distances = Airport.distance_between(airport_1, airport_2)

      expect(distances.keys).to include(:airport_1, :airport_2, :kilometers, :miles, :nautical_miles)
      expect(distances[:airport_1]).to eq(airport_1.iata)
      expect(distances[:airport_2]).to eq(airport_2.iata)
      expect(distances[:kilometers]).to be_a(Float)
      expect(distances[:miles]).to be_a(Float)
      expect(distances[:nautical_miles]).to be_a(Float)
    end
  end
end
