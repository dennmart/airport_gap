require 'rails_helper'

RSpec.describe Airport do
  describe 'associations' do
    it { is_expected.to have_many(:favorites) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:iata) }
  end
end
