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

  describe "#trigger_password_reset!" do
    let(:user) { create(:user) }

    it "generates a password reset token and sets a timestamp for the user" do
      expect(user.password_reset_token).to be_nil
      expect(user.password_reset_sent_at).to be_nil

      user.trigger_password_reset!
      expect(user.password_reset_token).to_not be_nil
      expect(user.password_reset_sent_at).to_not be_nil
    end

    it "sends an email with the password reset instructions"
  end

  describe "#password_reset_successful!" do
    let(:user) { create(:user, :with_password_reset) }

    it "clears the password reset token and timestamp for the user" do
      expect(user.password_reset_token).to_not be_nil
      expect(user.password_reset_sent_at).to_not be_nil

      user.password_reset_successful!
      expect(user.password_reset_token).to be_nil
      expect(user.password_reset_sent_at).to be_nil
    end

    it "sends an email to notify the user of the password reset"
  end
end
