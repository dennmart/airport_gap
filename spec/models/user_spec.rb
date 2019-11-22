require 'rails_helper'

RSpec.describe User, type: :model do
  describe "has_secure_token method" do
    it { should have_secure_token }
  end

  describe "has_secure_password method" do
    it { should have_secure_password }
  end

  describe "associations" do
    it { should have_many(:favorites) }
  end

  describe "validations" do
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
    it { should allow_values("email@example.com", "email@example.co.jp", "email@this.rocks").for(:email) }
    it { should_not allow_values("email@example", "email@example.c", "@test.com").for(:email) }
  end
end
