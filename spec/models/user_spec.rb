require 'rails_helper'

RSpec.describe User do
  describe 'has_secure_token method' do
    it { is_expected.to have_secure_token }
  end

  describe 'has_secure_password method' do
    it { is_expected.to have_secure_password }
  end

  describe 'associations' do
    it { is_expected.to have_many(:favorites) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email) }
    it { is_expected.to allow_values('email@example.com', 'email@example.co.jp', 'email@this.rocks').for(:email) }
    it { is_expected.to_not allow_values('email@example', 'email@example.c', '@test.com').for(:email) }
  end
end
