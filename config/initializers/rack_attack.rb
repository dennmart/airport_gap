Rack::Attack.safelist('allow any requests for testing purposes') do |request|
  # Requests are allowed if the return value is truthy
  testing_secret = Rails.application.credentials.dig(:testing, :secret_key)

  testing_secret.present? && request.env['HTTP_TESTING_SECRET'] == testing_secret
end

# Throttle all API endpoints to 100 requests per minute.
Rack::Attack.throttle('requests by IP address', limit: 100, period: 60) do |request|
  request.ip if request.path.start_with?('/api')
end

# Throttle simulated slow responses more aggressively, since each one occupies a
# web server thread for the length of the delay.
Rack::Attack.throttle('slow simulation requests by IP address', limit: 10, period: 60) do |request|
  scenario = request.env['HTTP_X_SIMULATE'].to_s.strip.downcase

  request.ip if request.path.start_with?('/api') && scenario.start_with?('slow')
end
