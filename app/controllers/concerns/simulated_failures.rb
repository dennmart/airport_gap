module SimulatedFailures
  extend ActiveSupport::Concern

  DEFAULT_DELAY = 2
  MAX_DELAY = 5

  MALFORMED_JSON = '{"data":{"id":"KIX","type":"airport","attributes":{"name":"Kansai Interna'.freeze

  SCENARIOS = %w[server-error service-unavailable slow malformed-json wrong-content-type].freeze

  included do
    prepend_before_action :simulate_failure, if: -> { request.headers['X-Simulate'].present? }
  end

  # Capped because each delayed request occupies a web server thread for its duration.
  def self.delay_for(option)
    return DEFAULT_DELAY if option.blank?

    option.to_i.clamp(1, MAX_DELAY)
  end

  private

  def simulate_failure
    scenario, option = request.headers['X-Simulate'].to_s.strip.downcase.split(':', 2)

    case scenario
    when 'server-error' then simulate_server_error
    when 'service-unavailable' then simulate_service_unavailable
    when 'slow' then sleep SimulatedFailures.delay_for(option)
    when 'malformed-json' then simulate_malformed_json
    when 'wrong-content-type' then simulate_wrong_content_type
    else simulate_unknown_scenario(scenario)
    end
  end

  def simulate_server_error
    render json: simulated_error_response(
      '500',
      'Internal Server Error',
      'A simulated error occurred while processing your request.'
    ), status: :internal_server_error
  end

  def simulate_service_unavailable
    response.headers['Retry-After'] = '30'

    render json: simulated_error_response(
      '503',
      'Service Unavailable',
      'The service is simulating downtime. Retry your request after 30 seconds.'
    ), status: :service_unavailable
  end

  def simulate_malformed_json
    render plain: MALFORMED_JSON, content_type: 'application/json'
  end

  def simulate_wrong_content_type
    render plain: { data: { id: 'KIX', type: 'airport' } }.to_json, content_type: 'text/html'
  end

  def simulate_unknown_scenario(scenario)
    render json: simulated_error_response(
      '400',
      'Bad Request',
      "'#{scenario}' is not a valid X-Simulate scenario. Valid scenarios are: #{SCENARIOS.join(', ')}."
    ), status: :bad_request
  end

  def simulated_error_response(status, title, detail)
    {
      errors: [{
        status: status,
        title: title,
        detail: detail
      }]
    }
  end
end
