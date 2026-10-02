require 'rails_helper'

RSpec.describe 'Docs' do
  describe '#index' do
    it 'sets a page-specific title and stays indexable' do
      get '/docs'
      expect(response).to have_http_status(:ok)
      page = response.parsed_body
      expect(page.at_css('title').text).to eq('REST API Docs and Endpoint Reference | Airport Gap')
      expect(page.at_css('meta[name="robots"]')).to be_nil
    end
  end
end
