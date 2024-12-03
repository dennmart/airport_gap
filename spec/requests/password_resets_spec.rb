require 'rails_helper'

RSpec.describe 'Password Resets' do
  describe 'GET /password_reset/new' do
    it 'renders successfully' do
      get '/password_reset/new'
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET /password_reset/edit' do
    let(:user) { create(:user) }

    it 'redirects to new password reset path if the user token is invalid or expired' do
      allow(User).to receive(:find_by_password_reset_token).with('password-reset-token').and_return(nil)

      get '/password_reset/edit', params: { password_reset_token: 'password-reset-token' }
      expect(response).to redirect_to(new_password_reset_path)
    end

    it 'renders successfully if the user token is valid' do
      get '/password_reset/edit', params: { password_reset_token: user.password_reset_token }
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST /password_reset' do
    let(:user) { create(:user) }

    before do
      allow(UserMailer).to receive(:password_reset_instructions).and_call_original
    end

    context 'when user is found' do
      before do
        allow(User).to receive(:find_by).with(email: user.email).and_return(user)
        allow(user).to receive(:password_reset_token).and_return('password-reset-token')
      end

      it 'sends an email with instructions for resetting the password' do
        post '/password_reset', params: { email: user.email }
        expect(UserMailer).to have_received(:password_reset_instructions).with(user.id, user.password_reset_token)
      end

      it 'redirects to new password reset path' do
        post '/password_reset', params: { email: user.email }
        expect(response).to redirect_to(new_password_reset_path)
      end
    end

    context 'when user is not found' do
      it 'does not send an email with instructions for resetting the password' do
        post '/password_reset', params: { email: 'non-existing-user@airportgap.com' }
        expect(UserMailer).to_not have_received(:password_reset_instructions).with(user.id)
      end

      it 'redirects to new password reset path' do
        post '/password_reset', params: { email: 'non-existing-user@airportgap.com' }
        expect(response).to redirect_to(new_password_reset_path)
      end
    end
  end

  describe 'PATCH /password_reset' do
    let(:user) { create(:user) }

    context 'when password reset token is valid and passwords match' do
      it 'updates the user password' do
        expect {
          patch '/password_reset',
                params: { password_reset_token: user.password_reset_token,
                          user: { password: 'new-password', password_confirmation: 'new-password' } }
        }.to(change { user.reload.password_digest })
      end

      it 'sends an email notification that the password has been reset' do
        allow(UserMailer).to receive(:password_change_notification).and_call_original

        patch '/password_reset',
              params: { password_reset_token: user.password_reset_token,
                        user: { password: 'new-password', password_confirmation: 'new-password' } }

        expect(UserMailer).to have_received(:password_change_notification).with(user.id)
      end

      it 'redirects to login path' do
        patch '/password_reset',
              params: { password_reset_token: user.password_reset_token,
                        user: { password: 'new-password', password_confirmation: 'new-password' } }

        expect(response).to redirect_to(login_path)
      end
    end

    context 'when password reset token is valid but passwords do not match' do
      it 'does not update the user password' do
        expect {
          patch '/password_reset',
                params: { password_reset_token: user.password_reset_token,
                          user: { password: 'new-password', password_confirmation: 'bad-password' } }
        }.to_not(change { user.reload.password_digest })
      end

      it 'does not send an email notification that the password has been reset' do
        allow(UserMailer).to receive(:password_change_notification).and_call_original

        patch '/password_reset',
              params: { password_reset_token: user.password_reset_token,
                        user: { password: 'new-password', password_confirmation: 'bad-password' } }

        expect(UserMailer).to_not have_received(:password_change_notification)
      end

      it 'renders the edit page' do
        patch '/password_reset',
              params: { password_reset_token: user.password_reset_token,
                        user: { password: 'new-password', password_confirmation: 'bad-password' } }

        expect(response).to render_template(:edit)
      end
    end

    context 'when password reset token is invalid or expired' do
      it 'does not update the user password' do
        expect {
          patch '/password_reset',
                params: { password_reset_token: 'invalid-password-reset-token',
                          user: { password: 'new-password', password_confirmation: 'new-password' } }
        }.to_not(change { user.reload.password_digest })
      end

      it 'does not send an email notification that the password has been reset' do
        allow(UserMailer).to receive(:password_change_notification).and_call_original

        patch '/password_reset',
              params: { password_reset_token: 'invalid-password-reset-token',
                        user: { password: 'new-password', password_confirmation: 'new-password' } }

        expect(UserMailer).to_not have_received(:password_change_notification)
      end

      it 'redirects to new password reset path' do
        patch '/password_reset',
              params: { password_reset_token: 'invalid-password-reset-token',
                        user: { password: 'new-password', password_confirmation: 'new-password' } }

        expect(response).to redirect_to(new_password_reset_path)
      end
    end
  end
end
