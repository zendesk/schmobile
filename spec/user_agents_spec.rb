require 'spec_helper'

describe Schmobile::UserAgents do
  describe '#remove_user_agent_pattern' do
    it 'allows removal of a user agent' do
      expect(Schmobile::UserAgents.is_mobile_agent?('novarra')).to be true

      Schmobile::UserAgents.remove_user_agent_pattern('novarra')

      expect(Schmobile::UserAgents.is_mobile_agent?('novarra')).to be false
    end
  end

  describe '#add_user_agent_pattern' do
    it 'allows adding a user agent' do
      expect(Schmobile::UserAgents.is_mobile_agent?('wibble')).to be false

      Schmobile::UserAgents.add_user_agent_pattern('wibble')

      expect(Schmobile::UserAgents.is_mobile_agent?('wibble')).to be true
    end

    it 'allows changing behavior for a non-mobile agent' do
      expect(Schmobile::UserAgents.is_mobile_agent?('ipad')).to be false

      Schmobile::UserAgents.add_user_agent_pattern('ipad')

      expect(Schmobile::UserAgents.is_mobile_agent?('ipad')).to be false

      Schmobile::UserAgents.remove_non_mobile_user_agent_pattern('ipad')

      expect(Schmobile::UserAgents.is_mobile_agent?('ipad')).to be true

      Schmobile::UserAgents.add_non_mobile_user_agent_pattern('ipad')
    end
  end

  describe '#is_mobile_agent?' do
    it 'returns false for common browsers' do
      [ :msie6, :msie8, :opera, :chrome ].each do |browser|
        agent = self.send(browser)
        expect(Schmobile::UserAgents.is_mobile_agent?(agent)). to be(false), "#{browser} should not detect as mobile, #{agent}"
      end
    end
  end
end
