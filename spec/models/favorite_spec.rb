require 'rails_helper'

RSpec.describe Favorite, type: :model do
  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:airport) }
  end
end
