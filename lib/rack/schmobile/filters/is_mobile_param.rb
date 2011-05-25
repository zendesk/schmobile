module Rack
  module Schmobile
    module Filters
      module IsMobileParam
        def self.call(request)
          if request.params.key?(Rack::Schmobile::IS_MOBILE)
            request.session[Rack::Schmobile::IS_MOBILE] = (request.params[Rack::Schmobile::IS_MOBILE] == "true")
          end

          request.session[Rack::Schmobile::IS_MOBILE]
        end
      end
    end
  end
end
