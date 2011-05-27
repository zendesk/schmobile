module Rack
  module Schmobile
    module Filters
      module IsMobileParam
        def self.call(request)
          if request.params.key?(Rack::Schmobile::IS_MOBILE)
             return request.params[Rack::Schmobile::IS_MOBILE] == "true"
          end

          nil
        end
      end
    end
  end
end
