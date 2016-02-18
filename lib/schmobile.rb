require 'rack'

begin
  require 'action_dispatch'
rescue LoadError
  # It's fine, actionpack isn't present
end

require 'schmobile/version'
require 'schmobile/middleware'
require 'schmobile/request_extension'
require 'schmobile/filters'

module Schmobile
  IS_MOBILE = 'is_mobile'
end
