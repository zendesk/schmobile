require 'rack'

module Rack

  # Rack::Schmobile is a minimalist mobile UA detection middleware
  class Schmobile
    MOBILE_USER_AGENTS = %w(
      palm blackberry nokia phone midp mobi symbian chtml ericsson minimo audiovox motorola samsung telit upg1 windows ce
      ucweb astel plucker x320 x240 j2me sgh portable sprint docomo kddi softbank android mmp pdxgw netfront xiino vodafone
      portalmmm sagem mot- sie- ipod up.b  webos amoi novarra cdm alcatel pocket ipad iphone mobileexplorer mobile
    )

    SCHMOBILE_MODE = 'schmobile_mode'

    def self.remove_user_agent_pattern(pattern)
      MOBILE_USER_AGENTS.delete(pattern)
      @mobile_agent_matcher = nil
    end

    def self.add_user_agent_pattern(pattern)
      MOBILE_USER_AGENTS.push(*pattern)
      @mobile_agent_matcher = nil
    end

    def self.is_mobile_request?(request)
      request.user_agent.to_s.downcase =~ mobile_agent_matcher
    end

    def self.mobile_agent_matcher
      @mobile_agent_matcher ||= Regexp.new(MOBILE_USER_AGENTS.uniq.compact.map { |v| Regexp.escape(v) }.join("|"))
    end

    def initialize(app, options = {})
      @app     = app
      @options = options
    end

    def call(env)
      request = Rack::Request.new(env)

      if is_mobile_session?(env, request) && redirect?(request)
        return [ 301, { "Location" => redirect(request) }, [] ]
      end

      @app.call(env)
    end

    # Checks if this session has been forced into mobile mode and returns that if that is the case. Otherwise
    # checks the user agent via request.is_mobile?
    def is_mobile_session?(env, request)
      session = env['rack.session'] ||= {}

      if request.params[SCHMOBILE_MODE]
        session[SCHMOBILE_MODE] = request.params[SCHMOBILE_MODE]
      end

      unless session[SCHMOBILE_MODE].nil?
        return session[SCHMOBILE_MODE] == 'enabled'
      end

      request.is_mobile?
    end

    # Returns true if this middleware has been configured with a redirect_to and the requested path is not already
    # below the configured redirect_to
    def redirect?(request)
      if @options[:if].is_a?(Proc)
        return false unless @options[:if].call(request)
      end

      !redirect(request).empty? && request.path !~ /^#{redirect(request)}/
    end

    def redirect(request)
      destination = @options[:redirect_to].to_s
      build_path(destination, request)
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

Rack::Request.class_eval do
  def is_mobile?
    Rack::Schmobile.is_mobile_request?(self)
  end
end
