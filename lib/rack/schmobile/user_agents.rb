module Rack
  module Schmobile
    class UserAgents

      MOBILE_USER_AGENTS = %w(
        alcatel amoi android astel audiovox blackberry cdm ce chtml danger docomo ericsson htc_touch
        iphone ipod j2me kddi midp minimo mmp mobi mobile mobileexplorer mot- motorola netfront nokia
        novarra palm pdxgw phone plucker pocket portable portalmmm sagem samsung sgh sie- softbank
        sprint symbian telit ucweb up.b upg1 vodafone webos windows x240 x320 xiino
      )

      def self.remove_user_agent_pattern(pattern)
        MOBILE_USER_AGENTS.delete(pattern)
        @mobile_agent_matcher = nil
      end

      def self.add_user_agent_pattern(pattern)
        MOBILE_USER_AGENTS.push(*pattern)
        @mobile_agent_matcher = nil
      end

      def self.is_mobile_agent?(user_agent)
        !(user_agent.to_s.downcase =~ mobile_agent_matcher).nil?
      end

      def self.mobile_agent_matcher
        @mobile_agent_matcher ||= Regexp.new(MOBILE_USER_AGENTS.uniq.compact.map { |v| Regexp.escape(v) }.join("|"))
      end

    end
  end
end
