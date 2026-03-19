require 'rails_helper'

RSpec.describe 'API Airports' do
  describe 'GET /api/airports/:id' do
    it 'returns information about a single airport' do
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

      get '/api/airports/KIX'

      expect(response).to have_http_status(:ok)
      expect(response.parsed_body).to eq(
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
      expect(response.parsed_body).to eq(
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

      body = response.parsed_body
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
      expect(response.parsed_body).to eq(
        'errors' => [{
          'status' => '422',
          'title' => 'Unable to process request',
          'detail' => "Please enter valid 'from' and 'to' airports."
        }]
      )
    end
  end

  describe 'GET /api/airports' do
    it 'returns a list of airports' do
      create(:airport)

      get '/api/airports'

      expect(response).to have_http_status(:ok)

      body = response.parsed_body

      expect(body['data']).to be_an(Array)
      expect(body['data']).to_not be_empty
      expect(body['data'].first).to include('id', 'type', 'attributes')
    end
  end
end
