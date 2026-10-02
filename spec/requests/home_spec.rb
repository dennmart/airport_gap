require 'rails_helper'

RSpec.describe 'Home' do
  describe '#index' do
    it 'renders successfully' do
      get '/'
      expect(response).to have_http_status(:ok)
    end

    it 'sets a page-specific title and description' do
      get '/'
      page = response.parsed_body
      title = 'API Testing Practice with a Free REST API | Airport Gap'
      expect(page.at_css('title').text).to eq(title)
      expect(page.at_css('meta[property="og:title"]')['content']).to eq(title)
      expect(page.at_css('meta[name="description"]')['content']).to start_with('Practice API testing against a free')
    end

    it 'links to TestNod' do
      get '/'
      links = response.parsed_body.css('a[href="https://testnod.com/"][target="_blank"][rel="noopener"]')
      expect(links.size).to eq(2)
    end
  end
end
