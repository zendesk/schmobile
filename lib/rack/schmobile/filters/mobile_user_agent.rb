require 'rack/schmobile/user_agents'

module Rack
  module Schmobile
    module Filters
      module MobileUserAgent
        def self.call(request)
          Rack::Schmobile::UserAgents.is_mobile_agent?(request.user_agent)
        end
      end
    end
  end
end
