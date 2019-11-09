require 'rails_helper'

RSpec.describe Airport, type: :model do
  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:iata) }
  end
end
