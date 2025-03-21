require 'rails_helper'

RSpec.describe CaptchaVerify, type: :service do
  describe '#call' do
    it 'makes a request to Cloudflare with the response and default secret key if not set' do
      stubbed_request = stub_request(:post, 'https://challenges.cloudflare.com/turnstile/v0/siteverify')
                        .with(body: { response: 'captcha-response', secret: '1x0000000000000000000000000000000AA' })

      service = CaptchaVerify.new('captcha-response')
      service.call

      expect(stubbed_request).to have_been_requested
    end

    it 'sets the secret key if set as an environment variable' do
      allow(ENV).to receive(:fetch)
        .with('CF_TURNSTILE_SECRET_KEY', '1x0000000000000000000000000000000AA')
        .and_return('cloudflare-secret')

      stubbed_request = stub_request(:post, 'https://challenges.cloudflare.com/turnstile/v0/siteverify')
                        .with(body: { response: 'captcha-response', secret: 'cloudflare-secret' })

      service = CaptchaVerify.new('captcha-response')
      service.call

      expect(stubbed_request).to have_been_requested
    end

    it 'returns true if the success key in the response body is true' do
      stub_request(:post, 'https://challenges.cloudflare.com/turnstile/v0/siteverify')
        .to_return(status: 200, body: '{"success": true}', headers: {})

      service = CaptchaVerify.new('captcha-response')
      expect(service.call).to be(true)
    end

    it 'returns false if the success key in the response body is false' do
      stub_request(:post, 'https://challenges.cloudflare.com/turnstile/v0/siteverify')
        .to_return(status: 200, body: '{"success": false}', headers: {})

      service = CaptchaVerify.new('captcha-response')
      expect(service.call).to be(false)
    end

    it 'returns false if response body does not have a success key' do
      stub_request(:post, 'https://challenges.cloudflare.com/turnstile/v0/siteverify')
        .to_return(status: 500, body: '{"bad-request": true}', headers: {})

      service = CaptchaVerify.new('captcha-response')
      expect(service.call).to be(false)
    end

    it 'returns false if response body cannot be parsed' do
      stub_request(:post, 'https://challenges.cloudflare.com/turnstile/v0/siteverify')
        .to_return(status: 500, body: 'invalid body', headers: {})

      service = CaptchaVerify.new('captcha-response')
      expect(service.call).to be(false)
    end
  end
end
