class ApiController < ApplicationController
  skip_before_action :verify_authenticity_token

  private

  def not_found_error_response
    {
      errors: [{
        status: "404",
        title: "Not Found",
        detail: "The page you requested could not be found"
      }]
    }
  end

  def unprocessable_entity_response(detail)
    {
      errors: [{
        status: "422",
        title: "Unable to process request",
        detail: detail
      }]
    }
  end
end