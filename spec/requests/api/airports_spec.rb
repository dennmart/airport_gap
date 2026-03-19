require 'rails_helper'

RSpec.describe 'API Airports' do
  describe 'GET /api/airports/:id' do
    it 'returns information about a single airport' do
      airport = create(:airport,
        name: 'Kansai International Airport',
        city: 'Osaka',
        country: 'Japan',
        iata: 'KIX',
        icao: 'RJBB',
        latitude: '34.427299',
        longitude: '135.244003',
        altitude: 26,
        timezone: 'Asia/Tokyo')

      get '/api/airports/KIX'

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to eq(
        'data' => {
          'id' => 'KIX',
          'type' => 'airport',
          'attributes' => {
            'altitude' => 26,
            'city' => 'Osaka',
            'country' => 'Japan',
            'iata' => 'KIX',
            'icao' => 'RJBB',
            'latitude' => '34.427299',
            'longitude' => '135.244003',
            'name' => 'Kansai International Airport',
            'timezone' => 'Asia/Tokyo'
          }
        }
      )
    end

    it 'returns 404 for a non-existent airport' do
      get '/api/airports/INVALID'

      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)).to eq(
        'errors' => [{
          'status' => '404',
          'title' => 'Not Found',
          'detail' => 'The page you requested could not be found'
        }]
      )
    end
  end

  describe 'POST /api/airports/distance' do
    it 'calculates the distance between two airports' do
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

      create(:airport,
        name: 'San Francisco International Airport',
        city: 'San Francisco',
        country: 'United States',
        iata: 'SFO',
        icao: 'KSFO',
        latitude: '37.618999',
        longitude: '-122.375',
        altitude: 13,
        timezone: 'America/Los_Angeles')

      post '/api/airports/distance',
        params: { from: 'KIX', to: 'SFO' },
        as: :json

      expect(response).to have_http_status(:ok)

      body = JSON.parse(response.body)
      data = body['data']

      expect(data['id']).to eq('KIX-SFO')
      expect(data['type']).to eq('airport_distance')

      attributes = data['attributes']
      expect(attributes['from_airport']['iata']).to eq('KIX')
      expect(attributes['to_airport']['iata']).to eq('SFO')
      expect(attributes['kilometers']).to be_a(Float)
      expect(attributes['miles']).to be_a(Float)
      expect(attributes['nautical_miles']).to be_a(Float)
    end

    it 'returns 422 for invalid airport codes' do
      post '/api/airports/distance',
        params: { from: 'INVALID', to: 'NOPE' },
        as: :json

      expect(response).to have_http_status(:unprocessable_content)
      expect(JSON.parse(response.body)).to eq(
        'errors' => [{
          'status' => '422',
          'title' => 'Unable to process request',
          'detail' => "Please enter valid 'from' and 'to' airports."
        }]
      )
    end
  end

  describe 'GET /api/airports' do
    it 'returns all airports with pagination' do
      create_list(:airport, 30)

      get '/api/airports'

      expect(response).to have_http_status(:ok)

      body = JSON.parse(response.body)

      expect(body['data']).to be_an(Array)
      expect(body['data']).not_to be_empty
      expect(body['data'].first).to include('id', 'type', 'attributes')

      expect(body['links']).to include('self', 'first', 'last', 'next', 'prev')
    end
  end
end
