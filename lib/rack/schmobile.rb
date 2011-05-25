require 'rack'
require 'rack/schmobile/middleware'
require 'rack/schmobile/request_extension'
require 'rack/schmobile/filters'

module Rack
  module Schmobile
    FILTERS   = [ Rack::Schmobile::Filters::IsMobileParam, Rack::Schmobile::Filters::MobileUserAgent ]
    IS_MOBILE = "is_mobile"
  end
end
