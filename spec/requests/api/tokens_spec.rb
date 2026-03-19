require 'rails_helper'

RSpec.describe 'API Tokens' do
  describe 'POST /api/tokens' do
    it 'returns an authentication token for valid credentials' do
      user = create(:user, email: 'test@example.com', password: 'testpassword')

      post '/api/tokens',
        params: { email: 'test@example.com', password: 'testpassword' },
        as: :json

      expect(response).to have_http_status(:ok)

      body = JSON.parse(response.body)
      expect(body['token']).to eq(user.token)
    end

    it 'returns unauthorized for invalid credentials' do
      create(:user, email: 'test@example.com', password: 'testpassword')

      post '/api/tokens',
        params: { email: 'test@example.com', password: 'wrongpassword' },
        as: :json

      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns unauthorized for a non-existent email' do
      post '/api/tokens',
        params: { email: 'nobody@example.com', password: 'anything' },
        as: :json

      expect(response).to have_http_status(:unauthorized)
    end
  end
end
