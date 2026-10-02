require 'rails_helper'

RSpec.describe 'Home' do
  describe '#index' do
    it 'renders successfully' do
      get '/'
      expect(response).to have_http_status(:ok)
    end

    it 'links to TestNod' do
      get '/'
      links = response.parsed_body.css('a[href="https://testnod.com/"][target="_blank"][rel="noopener"]')
      expect(links.size).to eq(2)
    end
  end
end
