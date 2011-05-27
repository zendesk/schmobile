module Rack
  module Schmobile
    module Filters
      module MobileSession
        def self.call(request)
          request.session[Rack::Schmobile::IS_MOBILE]
        end
      end
    end
  end
end
