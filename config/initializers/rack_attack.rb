# Throttle public endpoints to 10 requests per minute.
Rack::Attack.throttle("requests by ip", limit: 10, period: 60) do |request|
  if request.path.start_with?("/airports")
    request.ip
  end
end