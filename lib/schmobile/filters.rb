require 'schmobile/filters/mobile_session'
require 'schmobile/filters/is_mobile_param'
require 'schmobile/filters/mobile_user_agent'

module Schmobile
  # Filters are tests that get run against a request to determine if it's a mobile request or not.
  # A filter can return true, false or nil. The first non-nil value of the filter chain is the
  # one that gets used and this also gets used to mark the session as a "mobile session"
  #
  # You can manipulate the chain to add new conditions that check on e.g. request format.
  module Filters
    CHAIN = [
      Schmobile::Filters::IsMobileParam, # Must come before session check
      Schmobile::Filters::MobileSession,
      Schmobile::Filters::MobileUserAgent # Always returns either true or false
    ]

    def self.apply(request)
      Schmobile::Filters::CHAIN.each do |filter|
        result = filter.call(request)
        unless result.nil?
          request.session[Schmobile::IS_MOBILE] = result
          break
        end
      end

      request.session[Schmobile::IS_MOBILE] ||= false
    end
  end
end
