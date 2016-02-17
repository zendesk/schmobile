module Schmobile
  class UserAgents

    MOBILE_USER_AGENTS = %w(
      alcatel amoi android astel audiovox blackberry cdm chtml danger docomo ericsson htc_touch
      iphone ipod j2me kddi midp minimo mmp mobi mobile mobileexplorer mot- motorola netfront nokia
      novarra palm pdxgw phone plucker pocket portable portalmmm sagem samsung sgh sie- softbank
      sprint symbian telit ucweb up.b upg1 vodafone webos windows\ ce x240 x320 xiino
    )

    NON_MOBILE_USER_AGENTS = %w(
      ipad
    )

    def self.remove_user_agent_pattern(pattern)
      MOBILE_USER_AGENTS.delete(pattern)
      @mobile_agent_matcher = nil
    end

    def self.add_user_agent_pattern(pattern)
      MOBILE_USER_AGENTS.push(*pattern)
      @mobile_agent_matcher = nil
    end

    def self.remove_non_mobile_user_agent_pattern(pattern)
      NON_MOBILE_USER_AGENTS.delete(pattern)
      @non_mobile_agent_matcher = nil
    end

    def self.add_non_mobile_user_agent_pattern(pattern)
      NON_MOBILE_USER_AGENTS.push(*pattern)
      @non_mobile_agent_matcher = nil
    end

    def self.is_mobile_agent?(user_agent)
      agent  = user_agent.to_s.downcase
      mobile = !(agent =~ mobile_agent_matcher).nil?
      mobile = mobile && agent !~ non_mobile_agent_matcher unless NON_MOBILE_USER_AGENTS.empty?
      mobile
    end

    def self.mobile_agent_matcher
      @mobile_agent_matcher ||= Regexp.new(MOBILE_USER_AGENTS.uniq.compact.map { |v| Regexp.escape(v) }.join('|'))
    end

    def self.non_mobile_agent_matcher
      @non_mobile_agent_matcher ||= Regexp.new(NON_MOBILE_USER_AGENTS.uniq.compact.map { |v| Regexp.escape(v) }.join('|'))
    end

    def self.matched_by?(user_agent)
      MOBILE_USER_AGENTS.each do |agent|
        return agent if user_agent =~ /#{agent}/
      end
      nil
    end

  end
end
