module Rack
  module Schmobile
    module Request
      def is_mobile?
        Rack::Schmobile::Filters::CHAIN.each do |filter|
          result = filter.call(self)
          return result unless result.nil?
        end

        false
      end
    end
  end
end

Rack::Request.class_eval do
  include Rack::Schmobile::Request
end
