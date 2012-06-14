module Schmobile
  module Filters
    module MobileSession
      def self.call(request)
        request.session[Schmobile::IS_MOBILE]
      end
    end
  end
end
