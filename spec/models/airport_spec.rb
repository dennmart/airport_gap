require 'rails_helper'

RSpec.describe Airport, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:favorites) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:iata) }
  end

  describe '.distance_between' do
    let(:first_airport) { build(:airport) }
    let(:second_airport) { build(:airport) }

    it "raises an ArgumentError if both arguments aren't an Airport record" do
      expect {
        Airport.distance_between(first_airport, [])
      }.to raise_error(ArgumentError)

      expect {
        Airport.distance_between([], second_airport)
      }.to raise_error(ArgumentError)
    end

    it 'returns an OpenStruct object with the distance between airports in kilometers, miles, and nautical miles' do
      distances = Airport.distance_between(first_airport, second_airport)

      expect(distances).to be_an(OpenStruct)
      expect(distances.from_airport).to eq(first_airport)
      expect(distances.to_airport).to eq(second_airport)
      expect(distances.kilometers).to be_a(Float)
      expect(distances.miles).to be_a(Float)
      expect(distances.nautical_miles).to be_a(Float)
    end
  end
end
