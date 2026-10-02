require 'rails_helper'

RSpec.describe HomeHelper do
  describe '#http_example' do
    def render_lines(text, **)
      Nokogiri::HTML.fragment(helper.http_example(text, **)).children
    end

    it 'renders one element per line with its indentation' do
      lines = render_lines(<<~HTTP)
        POST /api/favorites HTTP/1.1
        Authorization: Bearer token=<your token>

        {
          "id": "1"
        }
      HTTP

      expect(lines.map(&:text)).to eq(['POST /api/favorites HTTP/1.1', 'Authorization: Bearer token=<your token>',
                                       ' ', '{', '"id": "1"', '}'])
      indents = lines.map { |line| line.attribute('style').value }
      expect(indents).to eq(%w[0 0 0 0 2 0].map { |indent| "--indent: #{indent}ch" })
    end

    it 'labels the request line and header names' do
      lines = render_lines("POST /api/favorites HTTP/1.1\nHost: airportgap.com\n")

      expect(lines[0].at_css('.http-start').text).to eq('POST /api/favorites HTTP/1.1')
      expect(lines[1].at_css('.http-header').text).to eq('Host:')
    end

    it 'marks lines that start with the highlighted text' do
      lines = render_lines("Host: airportgap.com\nX-Simulate: slow\n", highlight: 'X-Simulate:')

      expect(lines.map(&:name)).to eq(%w[span mark])
    end
  end
end
