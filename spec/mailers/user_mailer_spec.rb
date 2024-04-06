require 'rails_helper'

RSpec.describe UserMailer, type: :mailer do
  describe 'generated_token' do
    let(:user) { create(:user) }
    let(:mail) { UserMailer.generated_token(user.id) }

    it 'renders the proper headers' do
      expect(mail.from).to eq(['airportgap@dev-tester.com'])
      expect(mail.to).to eq([user.email])
      expect(mail.subject).to eq("Here's your generated token")
    end

    it "includes the user's token in the body" do
      expect(mail.body.encoded).to include(user.token)
    end
  end

  describe 'password_reset_instructions' do
    let(:user) { create(:user, :with_password_reset) }
    let(:mail) { UserMailer.password_reset_instructions(user.id) }

    it 'renders the proper headers' do
      expect(mail.from).to eq(['airportgap@dev-tester.com'])
      expect(mail.to).to eq([user.email])
      expect(mail.subject).to eq('Password reset instructions')
    end

    it 'includes the URL for resetting the password with the reset token in the body' do
      expect(mail.body.encoded).to include(edit_password_reset_url(password_reset_token: user.password_reset_token))
    end
  end

  describe 'password_change_notification' do
    let(:user) { create(:user) }
    let(:mail) { UserMailer.password_change_notification(user.id) }

    it 'renders the proper headers' do
      expect(mail.from).to eq(['airportgap@dev-tester.com'])
      expect(mail.to).to eq([user.email])
      expect(mail.subject).to eq('Your password has been reset')
    end
  end
end
