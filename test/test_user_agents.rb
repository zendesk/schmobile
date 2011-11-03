require 'helper'

class TestUserAgents < Test::Unit::TestCase

  context "Rack::Schmobile::UserAgents" do
    context "#remove_user_agent_pattern" do
      should "allow removal of a user agent" do
        assert Rack::Schmobile::UserAgents.is_mobile_agent?("novarra")
        Rack::Schmobile::UserAgents.remove_user_agent_pattern("novarra")
        assert !Rack::Schmobile::UserAgents.is_mobile_agent?("novarra")
      end
    end

    context "#add_user_agent_pattern" do
      should "allow adding a user agent" do
        assert !Rack::Schmobile::UserAgents.is_mobile_agent?("wibble")
        Rack::Schmobile::UserAgents.add_user_agent_pattern("wibble")
        assert Rack::Schmobile::UserAgents.is_mobile_agent?("wibble")
      end

      should "allow changing behavior for a non-mobile agent" do
        assert !Rack::Schmobile::UserAgents.is_mobile_agent?("ipad")
        Rack::Schmobile::UserAgents.add_user_agent_pattern("ipad")
        assert !Rack::Schmobile::UserAgents.is_mobile_agent?("ipad")
        Rack::Schmobile::UserAgents.remove_non_mobile_user_agent_pattern("ipad")
        assert Rack::Schmobile::UserAgents.is_mobile_agent?("ipad")
        Rack::Schmobile::UserAgents.add_non_mobile_user_agent_pattern("ipad")
      end
    end

    context "#is_mobile_agent?" do
      should "return false for common browsers" do
        [ :msie6, :msie8, :opera, :chrome ].each do |browser|
          agent = self.send(browser)
          assert !Rack::Schmobile::UserAgents.is_mobile_agent?(agent), "#{browser} should not detect as mobile, #{agent}"
        end
      end
    end
  end

end
