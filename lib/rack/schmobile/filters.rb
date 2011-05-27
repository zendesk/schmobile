require 'rack/schmobile/filters/mobile_session'
require 'rack/schmobile/filters/is_mobile_param'
require 'rack/schmobile/filters/mobile_user_agent'

module Rack
  module Schmobile
    # Filters are tests that get run against a request to detrmine if it's a mobile request or not.
    # A filter can return true, false or nil. The first non-nil value of the filter chain is the
    # one that gets used.
    #
    # You can modify the chain to add new conditions that check on e.g. request format.
    module Filters
      CHAIN = [
        Rack::Schmobile::Filters::MobileSession,
        Rack::Schmobile::Filters::IsMobileParam,
        Rack::Schmobile::Filters::MobileUserAgent
      ]

      def self.apply(request)
        Rack::Schmobile::Filters::CHAIN.each do |filter|
          result = filter.call(request)

          unless result.nil?
            request.session[Rack::Schmobile::IS_MOBILE] = result
            return result
          end
        end

        false
      end
    end
  end
end

