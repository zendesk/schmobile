require 'rack'

require 'schmobile/middleware'
require 'schmobile/request_extension'
require 'schmobile/filters'

module Schmobile
  VERSION   = "0.5.0"
  IS_MOBILE = "is_mobile"
end
