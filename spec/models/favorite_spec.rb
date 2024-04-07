require 'rails_helper'

RSpec.describe Favorite do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:airport) }
  end
end
