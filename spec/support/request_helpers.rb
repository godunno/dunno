module Requests
  module JsonHelpers
    def json
      @json ||= JSON.parse(last_response.body)
    end
  end

  module ControllerHelpers
    def controller
      last_request.env["action_controller.instance"]
    end
  end
end

RSpec.configure do |config|
  config.include Requests::JsonHelpers, type: :request
  config.include Requests::ControllerHelpers, type: :request
end
