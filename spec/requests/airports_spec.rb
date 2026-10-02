require 'rails_helper'

RSpec.describe 'Airports' do
  describe '#index' do
    it 'renders successfully' do
      get '/airports'
      expect(response).to have_http_status(:ok)
    end

    it 'includes the page number in the title after the first page' do
      get '/airports', params: { page: 2 }
      expect(response.parsed_body.at_css('title').text).to eq('List of Airports (Page 2) | Airport Gap')
    end
  end
end
