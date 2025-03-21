require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#captcha' do
    it 'returns a div tag with the class cf-turnstile and a default Cloudflare site key if not set' do
      expect(helper.captcha).to eq('<div class="cf-turnstile" data-sitekey="1x00000000000000000000AA"></div>')
    end

    it 'sets the site key if set as an environment variable' do
      allow(ENV).to receive(:fetch)
        .with('CF_TURNSTILE_SITE_KEY', '1x00000000000000000000AA')
        .and_return('cloudflare-site-key')

      expect(helper.captcha).to eq('<div class="cf-turnstile" data-sitekey="cloudflare-site-key"></div>')
    end
  end
end
