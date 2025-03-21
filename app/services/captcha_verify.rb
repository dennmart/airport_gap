require 'net/http'

class CaptchaVerify
  def initialize(response)
    @response = response
  end

  def call
    uri = URI.parse('https://challenges.cloudflare.com/turnstile/v0/siteverify')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri.request_uri)
    request.set_form_data({
                            'secret' => ENV.fetch('CF_TURNSTILE_SECRET_KEY', '1x0000000000000000000000000000000AA'),
                            'response' => @response
                          })

    response = http.request(request)

    begin
      result = JSON.parse(response.body)
      result['success'] || false
    rescue StandardError
      false
    end
  end
end
