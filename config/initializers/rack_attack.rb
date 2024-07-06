Rack::Attack.safelist('allow any requests for testing purposes') do |request|
  # Requests are allowed if the return value is truthy
  request.env['HTTP_TESTING_SECRET'] == Rails.application.credentials.dig(:testing, :secret_key)
end

# Throttle all API endpoints to 100 requests per minute.
Rack::Attack.throttle('requests by IP address', limit: 100, period: 60) do |request|
  request.ip if request.path.start_with?('/api')
end
