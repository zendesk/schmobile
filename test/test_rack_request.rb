require 'helper'

class TestRackRequest < Test::Unit::TestCase

  context "Rack::Request" do
    context "#is_mobile?" do
      context "without params" do
        setup do
          Rack::Request.any_instance.stubs(:params).returns({})
        end

        should "not detect a regular browser as mobile" do
          assert !request.is_mobile?
          assert !request("HTTP_USER_AGENT" => nil).is_mobile?
        end

        should "detect mobile units as mobile" do
          [ :ipod, :iphone, :android, :blackberry, :samsung ].each do |phone|
            agent = self.send(phone)
            assert request("HTTP_USER_AGENT" => agent).is_mobile?
          end
        end

        should "return false when forced in the session" do
          Rack::Request.any_instance.stubs(:session).returns({ Rack::Schmobile::IS_MOBILE => false })
          assert !request("HTTP_USER_AGENT" => iphone).is_mobile?
        end

        should "return true when forced in the session" do
          Rack::Request.any_instance.stubs(:session).returns({ Rack::Schmobile::IS_MOBILE => true })
          assert request.is_mobile?
        end
      end

      context "with params" do
        should "return false when forced via a request parameter" do
          Rack::Request.any_instance.stubs(:params).returns({ Rack::Schmobile::IS_MOBILE => "false" })
          assert !request("HTTP_USER_AGENT" => iphone).is_mobile?
        end

        should "return true when forced via a request parameter" do
          Rack::Request.any_instance.stubs(:params).returns({ Rack::Schmobile::IS_MOBILE => "true" })
          assert request.is_mobile?
        end
      end
    end
  end
end
