require 'rails_helper'

RSpec.describe 'API Favorites' do
  describe 'GET /api/favorites' do
    it 'returns all favorites for the authenticated user' do
      user = create(:user)
      create_list(:favorite, 3, user: user)

      get '/api/favorites',
        headers: { 'Authorization' => "Bearer token=#{user.token}" }

      expect(response).to have_http_status(:ok)

      body = JSON.parse(response.body)

      expect(body['data']).to be_an(Array)
      expect(body['data']).not_to be_empty
      expect(body['data'].first).to include('id', 'type', 'attributes')

      expect(body['links']).to include('self', 'first', 'last', 'next', 'prev')
    end
  end

  describe 'end-to-end favorites CRUD flow' do
    let(:user) { create(:user) }
    let(:auth_headers) { { 'Authorization' => "Bearer token=#{user.token}" } }

    let!(:airport) do
      create(:airport,
        name: 'Kansai International Airport',
        city: 'Osaka',
        country: 'Japan',
        iata: 'KIX',
        icao: 'RJBB',
        latitude: '34.427299',
        longitude: '135.244003',
        altitude: 26,
        timezone: 'Asia/Tokyo')
    end

    it 'creates, reads, updates, and deletes a favorite' do
      # Create a favorite
      post '/api/favorites',
        params: { airport_id: 'KIX', note: 'My local airport' },
        headers: auth_headers,
        as: :json

      expect(response).to have_http_status(:created)
      favorite_id = JSON.parse(response.body).dig('data', 'id')

      # Fetch the newly created favorite
      get "/api/favorites/#{favorite_id}", headers: auth_headers

      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body).to eq(
        'data' => {
          'id' => favorite_id.to_s,
          'type' => 'favorite',
          'attributes' => {
            'airport' => {
              'id' => airport.id,
              'altitude' => 26,
              'city' => 'Osaka',
              'country' => 'Japan',
              'iata' => 'KIX',
              'icao' => 'RJBB',
              'latitude' => '34.427299',
              'longitude' => '135.244003',
              'name' => 'Kansai International Airport',
              'timezone' => 'Asia/Tokyo'
            },
            'note' => 'My local airport'
          }
        }
      )

      # Update the favorite
      patch "/api/favorites/#{favorite_id}",
        params: { note: 'My local airport, goes everywhere in the world!' },
        headers: auth_headers,
        as: :json

      expect(response).to have_http_status(:ok)

      # Verify the update
      get "/api/favorites/#{favorite_id}", headers: auth_headers

      updated_body = JSON.parse(response.body)
      expect(updated_body.dig('data', 'attributes', 'note')).to eq('My local airport, goes everywhere in the world!')

      # Delete the favorite
      delete "/api/favorites/#{favorite_id}", headers: auth_headers

      expect(response).to have_http_status(:no_content)

      # Ensure the favorite is deleted
      get "/api/favorites/#{favorite_id}", headers: auth_headers

      expect(response).to have_http_status(:not_found)
    end
  end
end
