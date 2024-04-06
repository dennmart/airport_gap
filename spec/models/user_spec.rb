require 'rails_helper'

RSpec.describe User, type: :model do
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

  describe '#trigger_password_reset!' do
    let(:user) { create(:user) }

    it 'generates a password reset token and sets a timestamp for the user' do
      expect(user.password_reset_token).to be_nil
      expect(user.password_reset_sent_at).to be_nil

      user.trigger_password_reset!
      expect(user.password_reset_token).to_not be_nil
      expect(user.password_reset_sent_at).to_not be_nil
    end

    it 'queues an email with the password reset instructions' do
      expect {
        user.trigger_password_reset!
      }.to change { Sidekiq::Worker.jobs.size }.by(1)

      Sidekiq::Worker.drain_all
      mail = ActionMailer::Base.deliveries.first
      expect(mail.subject).to eq('Password reset instructions')
    end
  end

  describe '#password_reset_successful!' do
    let(:user) { create(:user, :with_password_reset) }

    it 'clears the password reset token and timestamp for the user' do
      expect(user.password_reset_token).to_not be_nil
      expect(user.password_reset_sent_at).to_not be_nil

      user.password_reset_successful!
      expect(user.password_reset_token).to be_nil
      expect(user.password_reset_sent_at).to be_nil
    end

    it 'sends an email to notify the user of the password reset' do
      expect {
        user.password_reset_successful!
      }.to change { Sidekiq::Worker.jobs.size }.by(1)

      Sidekiq::Worker.drain_all
      mail = ActionMailer::Base.deliveries.first
      expect(mail.subject).to eq('Your password has been reset')
    end
  end
end
