require 'schmobile/user_agents'

module Schmobile
  module Filters
    module MobileUserAgent
      def self.call(request)
        request.session[Schmobile::IS_MOBILE] = Schmobile::UserAgents.is_mobile_agent?(request.user_agent)
      end
    end
  end
end
