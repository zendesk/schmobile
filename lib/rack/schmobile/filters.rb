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
      CHAIN = [ Rack::Schmobile::Filters::IsMobileParam, Rack::Schmobile::Filters::MobileUserAgent ]
    end
  end
end

