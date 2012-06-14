require 'helper'

class TestMiddleware < Test::Unit::TestCase

  context "Schmobile::Middleware" do
    setup do
      @app  = Class.new { def call(app); true; end }.new
      @rack = Schmobile::Middleware.new(@app)
    end

    should "return an HTTP permanent redirect when given a redirect path and used by a mobile client" do
      @rack = Schmobile::Middleware.new(@app, :redirect_to => "/hello")
      Rack::Request.any_instance.expects(:is_mobile?).returns(true)

      assert_equal [301, { "Location"=>"/hello" }, []], @rack.call(environment)
    end

    context "with no redirect_to" do
      should "not redirect mobile traffic" do
        Rack::Request.any_instance.expects(:params).returns({})
        @app.expects(:call)
        @rack.call(environment("HTTP_USER_AGENT" => iphone))
      end

      should "query the request object to determine if this is a mobile request" do
        Rack::Request.any_instance.expects(:is_mobile?).returns(true)
        @rack.call(environment("HTTP_USER_AGENT" => iphone))
      end
    end

    context "with redirect_to" do
      setup do
        @rack = Schmobile::Middleware.new(@app, :redirect_to => "/wonderland")
      end

      context "#redirect?" do
        should "return true when not on mobile path" do
          assert @rack.redirect?(request("PATH_INFO" => "/somewhere"))
        end

        should "return true on base path" do
          assert @rack.redirect?(request("PATH_INFO" => "/"))
        end

        should "return false when already on path" do
          assert !@rack.redirect?(request("PATH_INFO" => "/wonderland"))
          assert !@rack.redirect?(request("PATH_INFO" => "/wonderland/more/stuff"))
        end

        should "return false when :if resolves to false" do
          @rack = Schmobile::Middleware.new(@app, :redirect_to => "/wonderland", :redirect_if => Proc.new { |request| false })
          assert !@rack.redirect?(request("PATH_INFO" => "/somewhere"))
        end
      end

      context "#redirect" do
        should "interpolate the argument string xxxx" do
          @rack = Schmobile::Middleware.new(@app, :redirect_to => "/wonderland", :redirect_with => "/{{path}}")
          assert_equal "/wonderland/wiffle", @rack.redirect_location(request("PATH_INFO" => "wiffle"))
        end

        should "interpolate a multipart argument string" do
          @rack = Schmobile::Middleware.new(@app, :redirect_to => "/wonderland/", :redirect_with => "{{path}}/lemurs/{{path}}")
          assert_equal "/wonderland/wiffle/lemurs/wiffle", @rack.redirect_location(request("PATH_INFO" => "wiffle"))
        end
      end
    end
  end
end
