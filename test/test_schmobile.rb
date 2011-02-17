require 'helper'

class TestSchmobile < Test::Unit::TestCase
  context "Rack::Request" do
    context "#is_mobile?" do
      should "not detect a regular browser as mobile" do
        assert !Rack::Request.new(environment).is_mobile?
        assert !Rack::Request.new("HTTP_USER_AGENT" => nil).is_mobile?
      end

      should "detect mobile units as mobile" do
        [ :ipod, :iphone, :android, :blackberry, :samsung ].each do |phone|
          agent = self.send(phone)
          assert Rack::Request.new(environment("HTTP_USER_AGENT" => agent)).is_mobile?
        end
      end
    end
  end

  context "Rack::Schmobile class" do
    context "#remove_user_agent_pattern" do
      should "allow removal of a user agent" do
        request = stub(:user_agent => "novarra")
        assert Rack::Schmobile.is_mobile_request?(request)
        Rack::Schmobile.remove_user_agent_pattern("novarra")
        assert !Rack::Schmobile.is_mobile_request?(request)
      end
    end

    context "#add_user_agent_pattern" do
      should "allow adding a user agent" do
        request = stub(:user_agent => "wibble")
        assert !Rack::Schmobile.is_mobile_request?(request)
        Rack::Schmobile.add_user_agent_pattern("wibble")
        assert Rack::Schmobile.is_mobile_request?(request)
      end
    end
  end

  context "Rack::Schmobile" do
    setup do
      @app  = Class.new { def call(app); true; end }.new
      @rack = Rack::Schmobile.new(@app)
    end

    should "return an HTTP permanent redirect when given a redirect path and used by a mobile client" do
      @rack.stubs(:redirect).returns("/hello")
      @rack.expects(:is_mobile_session?).returns(true)

      assert_equal [301, {"Location"=>"/hello"}, []], @rack.call(environment)
    end

    context "#is_mobile_session?" do
      should "return false for regular browsers" do
        Rack::Request.any_instance.expects(:params).returns({})
        assert !@rack.is_mobile_session?(environment)
      end

      should "return true for a mobile browser" do
        Rack::Request.any_instance.expects(:params).returns({})
        assert @rack.is_mobile_session?(environment("HTTP_USER_AGENT" => iphone))
      end

      should "return false when forced in the session" do
        Rack::Request.any_instance.expects(:params).returns({})
        Rack::Request.any_instance.expects(:is_mobile?).never

        assert !@rack.is_mobile_session?(environment("HTTP_USER_AGENT" => iphone, "rack.session" => { Rack::Schmobile::SCHMOBILE_MODE => "disabled" }))
      end

      should "return true when forced in the session" do
        Rack::Request.any_instance.expects(:params).returns({})
        Rack::Request.any_instance.expects(:is_mobile?).never

        assert @rack.is_mobile_session?(environment("rack.session" => { Rack::Schmobile::SCHMOBILE_MODE => "enabled" }))
      end

      should "return false when forced via a request parameter" do
        Rack::Request.any_instance.stubs(:params).returns({ Rack::Schmobile::SCHMOBILE_MODE => "disabled" })
        Rack::Request.any_instance.expects(:is_mobile?).never

        assert !@rack.is_mobile_session?(environment("HTTP_USER_AGENT" => iphone))
      end

      should "return true when forced via a request parameter" do
        Rack::Request.any_instance.stubs(:params).returns({ Rack::Schmobile::SCHMOBILE_MODE => "enabled" })
        Rack::Request.any_instance.expects(:is_mobile?).never

        assert @rack.is_mobile_session?(environment)
      end
    end

    context "with no redirect_to" do
      should "not redirect mobile traffic" do
        Rack::Request.any_instance.expects(:params).returns({})

        @app.expects(:call)
        @rack.call(environment("HTTP_USER_AGENT" => iphone))
      end

      should "query the request object to determine if this is a mobile request" do
        Rack::Request.any_instance.expects(:params).returns({})
        Rack::Request.any_instance.expects(:is_mobile?).returns(true)

        @rack.call(environment("HTTP_USER_AGENT" => iphone))
      end
    end

    context "with redirect_to" do
      setup do
        @rack = Rack::Schmobile.new(@app, :redirect_to => "/wonderland")
      end

      context "#redirect?" do
        should "return true when not on mobile path" do
          assert @rack.redirect?(environment("PATH_INFO" => "/somewhere"))
        end

        should "return true on base path" do
          assert @rack.redirect?(environment("PATH_INFO" => "/"))
        end

        should "return false when already on path" do
          assert !@rack.redirect?(environment("PATH_INFO" => "/wonderland"))
        end
      end

      context "#redirect" do
        should "interpolate the argument string" do
          @rack = Rack::Schmobile.new(@app, :redirect_to => "/wonderland/{{path}}")
          assert_equal "/wonderland/wiffle", @rack.redirect(environment("PATH_INFO" => "wiffle"))
        end
        should "interpolate a multipart argument string" do
          @rack = Rack::Schmobile.new(@app, :redirect_to => "/wonderland/{{path}}/lemurs/{{path}}")
          assert_equal "/wonderland/wiffle/lemurs/wiffle", @rack.redirect(environment("PATH_INFO" => "wiffle"))
        end
      end
    end

  end

  # User agents for testing
  def ipod
    'Mozilla/5.0 (iPod; U; CPU iPhone OS 2_2 like Mac OS X; en-us) AppleWebKit/525.18.1 (KHTML, like Gecko) Version/3.1.1 Mobile/5G77 Safari/525.20'
  end

  def iphone
    'Mozilla/5.0 (iPhone; U; CPU iPhone OS 3_1 like Mac OS X; en-us) AppleWebKit/528.18 (KHTML, like Gecko) Version/4.0 Mobile/7C144 Safari/528.16'
  end

  def android
    'Mozilla/5.0 (Linux; U; Android 2.0; ld-us; sdk Build/ECLAIR) AppleWebKit/530.17 (KHTML, like Gecko) Version/4.0 Mobile Safari/530.17'
  end

  def blackberry
    'BlackBerry9000/4.6.0.167 Profile/MIDP-2.0 Configuration/CLDC-1.1 VendorID/102'
  end

  def samsung
    'Mozilla/4.0 (compatible; MSIE 6.0; BREW 3.1.5; en )/800x480 Samsung SCH-U960'
  end

  def environment(overwrite = {})
     {
       'GATEWAY_INTERFACE'=> 'CGI/1.2',
       'HTTP_ACCEPT'=> 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
       'HTTP_ACCEPT_CHARSET'=> 'ISO-8859-1,utf-8;q=0.7,*;q=0.7',
       'HTTP_ACCEPT_ENCODING'=> 'gzip,deflate',
       'HTTP_ACCEPT_LANGUAGE'=> 'en-us,en;q=0.5',
       'HTTP_CONNECTION'=> 'keep-alive',
       'HTTP_HOST'=> 'localhost:4567',
       'HTTP_KEEP_ALIVE'=> 300,
       'HTTP_USER_AGENT'=> 'Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.3) Gecko/20090920 Firefox/3.5.3 (Swiftfox)',
       'HTTP_VERSION'=> 'HTTP/1.1',
       'PATH_INFO'=> '/',
       'QUERY_STRING'=> '',
       'REMOTE_ADDR'=> '127.0.0.1',
       'REQUEST_METHOD'=> 'GET',
       'REQUEST_PATH'=> '/',
       'REQUEST_URI'=> '/',
       'SCRIPT_NAME'=> '',
       'SERVER_NAME'=> 'localhost',
       'SERVER_PORT'=> '4567',
       'SERVER_PROTOCOL'=> 'HTTP/1.1',
       'SERVER_SOFTWARE'=> 'Mongrel 1.1.5',
       'rack.multiprocess'=> false,
       'rack.multithread'=> true,
       'rack.request.form_hash'=> '',
       'rack.request.form_vars'=> '',
       'rack.request.query_hash'=> '',
       'rack.request.query_string'=> '',
       'rack.run_once'=> false,
       'rack.url_scheme'=> 'http',
       'rack.version'=> '1: 0'
     }.merge(overwrite)
   end
end
