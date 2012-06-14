module Schmobile
  module Filters
    module IsMobileParam
      def self.call(request)
        if request.params.key?(Schmobile::IS_MOBILE)
           request.session[Schmobile::IS_MOBILE] = (request.params[Schmobile::IS_MOBILE] == "true")
        end

        nil
      end
    end
  end
end
