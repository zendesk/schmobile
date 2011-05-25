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
    end
  end

end
