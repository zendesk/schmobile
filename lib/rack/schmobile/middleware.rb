module Rack
  module Schmobile
    class Middleware

      def initialize(app, options = {})
        @app     = app
        @options = options
      end

      def call(env)
        request = Rack::Request.new(env)

        if request.is_mobile? && redirect?(request)
          [ 301, { "Location" => redirect_location(request) }, [] ]
        else
          @app.call(env)
        end
      end

      # Returns true if this middleware has been configured with a redirect_to and the requested path
      # is not already below the configured redirect_to
      def redirect?(request)
        redirecting = true

        if @options.key?(:redirect_if)
          redirecting = @options[:redirect_if].call(request)
        end

        if @options.key?(:redirect_to)
          redirecting &&= request.path !~ /^#{@options[:redirect_to]}/
        else
          redirecting = false
        end

        redirecting ? redirect_location(request) : nil
      end

      def redirect_location(request)
        "#{@options[:redirect_to]}#{redirect_with(request)}"
      end

      def redirect_with(request)
        build_path(@options[:redirect_with].to_s, request)
      end

      private

      def build_path(destination, request)
        final_destination = destination.dup
        destination.scan(/\{\{\w+\}\}/) do |call|
          func = call.scan(/\w+/).to_s
          if request.respond_to?(func)
            final_destination.sub!(/\{\{#{func}\}\}/, request.send(func))
          end
        end
        final_destination
      end

    end
  end
end
