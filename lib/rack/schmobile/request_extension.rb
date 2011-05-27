module Rack
  module Schmobile
    module Request
      def is_mobile?
        if @is_mobile.nil?
          @is_mobile = Rack::Schmobile::Filters.apply(self)
        end

        @is_mobile
      end

      def toggle_mobile_session!
        session[Rack::Schmobile::IS_MOBILE] = !is_mobile?
        @is_mobile = nil
      end

      def is_device?(identifier)
        user_agent =~ /#{identifier}/i
      end
    end
  end
end

Rack::Request.class_eval do
  include Rack::Schmobile::Request
end
