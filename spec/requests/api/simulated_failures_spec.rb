require 'rails_helper'

RSpec.describe 'API Simulated Failures' do
  before { create(:airport, iata: 'KIX') }

  describe 'X-Simulate: server-error' do
    it 'responds with a 500 error' do
      get '/api/airports', headers: { 'X-Simulate' => 'server-error' }

      expect(response).to have_http_status(:internal_server_error)
      expect(response.parsed_body).to eq(
        'errors' => [{
          'status' => '500',
          'title' => 'Internal Server Error',
          'detail' => 'A simulated error occurred while processing your request.'
        }]
      )
    end
  end

  describe 'X-Simulate: service-unavailable' do
    it 'responds with a 503 error and a Retry-After header' do
      get '/api/airports', headers: { 'X-Simulate' => 'service-unavailable' }

      expect(response).to have_http_status(:service_unavailable)
      expect(response.headers['Retry-After']).to eq('30')
      expect(response.parsed_body['errors'].first).to include('status' => '503', 'title' => 'Service Unavailable')
    end
  end

  describe 'X-Simulate: slow' do
    before { allow(SimulatedFailures).to receive(:delay_for).and_return(0) }

    it 'delays the response but still returns the normal payload' do
      get '/api/airports', headers: { 'X-Simulate' => 'slow' }

      expect(SimulatedFailures).to have_received(:delay_for).with(nil)
      expect(response).to have_http_status(:ok)
      expect(response.parsed_body['data'].first['id']).to eq('KIX')
    end

    it 'passes the requested delay through when one is given' do
      get '/api/airports', headers: { 'X-Simulate' => 'slow:4' }

      expect(SimulatedFailures).to have_received(:delay_for).with('4')
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'X-Simulate: malformed-json' do
    it 'responds with an unparseable body and a JSON content type' do
      get '/api/airports', headers: { 'X-Simulate' => 'malformed-json' }

      expect(response).to have_http_status(:ok)
      expect(response.media_type).to eq('application/json')
      expect { response.parsed_body }.to raise_error(JSON::ParserError)
    end
  end

  describe 'X-Simulate: wrong-content-type' do
    it 'responds with a valid JSON body under an HTML content type' do
      get '/api/airports', headers: { 'X-Simulate' => 'wrong-content-type' }

      expect(response).to have_http_status(:ok)
      expect(response.media_type).to eq('text/html')
      expect(response.body).to eq({ data: { id: 'KIX', type: 'airport' } }.to_json)
    end
  end

  describe 'an unknown scenario' do
    it 'responds with a 400 listing the valid scenarios' do
      get '/api/airports', headers: { 'X-Simulate' => 'explode' }

      expect(response).to have_http_status(:bad_request)

      error = response.parsed_body['errors'].first
      expect(error).to include('status' => '400', 'title' => 'Bad Request')
      expect(error['detail']).to include("'explode' is not a valid X-Simulate scenario")
      SimulatedFailures::SCENARIOS.each do |scenario|
        expect(error['detail']).to include(scenario)
      end
    end
  end

  describe 'scenario parsing' do
    it 'ignores surrounding whitespace and letter casing' do
      get '/api/airports', headers: { 'X-Simulate' => '  Server-Error  ' }

      expect(response).to have_http_status(:internal_server_error)
    end
  end

  describe 'without the header' do
    it 'responds normally' do
      get '/api/airports'

      expect(response).to have_http_status(:ok)
      expect(response.parsed_body['data'].first['id']).to eq('KIX')
    end
  end

  describe 'on an authenticated endpoint' do
    it 'simulates the failure before authenticating the request' do
      get '/api/favorites', headers: { 'X-Simulate' => 'server-error' }

      expect(response).to have_http_status(:internal_server_error)
    end

    it 'still authenticates requests that do not simulate a failure' do
      get '/api/favorites'

      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe SimulatedFailures do
    describe '.delay_for' do
      it 'uses the default delay when no value is given' do
        expect(SimulatedFailures.delay_for(nil)).to eq(SimulatedFailures::DEFAULT_DELAY)
        expect(SimulatedFailures.delay_for('')).to eq(SimulatedFailures::DEFAULT_DELAY)
      end

      it 'uses the requested delay when it is within the allowed range' do
        expect(SimulatedFailures.delay_for('3')).to eq(3)
      end

      it 'caps the delay at the maximum' do
        expect(SimulatedFailures.delay_for('99')).to eq(SimulatedFailures::MAX_DELAY)
      end

      it 'falls back to a one second delay for values below the minimum' do
        expect(SimulatedFailures.delay_for('0')).to eq(1)
        expect(SimulatedFailures.delay_for('not-a-number')).to eq(1)
      end
    end
  end
end
