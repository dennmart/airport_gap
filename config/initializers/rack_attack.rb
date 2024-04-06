# Throttle all API endpoints to 100 requests per minute.
Rack::Attack.throttle('requests by IP address', limit: 100, period: 60) do |request|
  request.ip if request.path.start_with?('/api')
end
