require 'helper'

class TestFukters < Test::Unit::TestCase

  context "Schmobile::Filters" do
    context "#apply" do
      setup do
        @request = stub(:user_agent => msie8)
        @request.stubs(:params).returns({})
        @session = {}
        @request.stubs(:session).returns(@session)
      end

      context "on a pristine request" do
        should "return true if the session is already mobile" do
          Schmobile::UserAgents.expects(:is_mobile_agent?).never
          @session[Schmobile::IS_MOBILE] = true
          assert Schmobile::Filters.apply(@request)
        end

        should "return true if there's an is_mobile parameter with value true" do
          Schmobile::UserAgents.expects(:is_mobile_agent?).never
          @request.stubs(:params).returns({ "is_mobile" => "true" })
          assert Schmobile::Filters.apply(@request)
        end

        should "return false if there's an is_mobile parameter with value false" do
          Schmobile::UserAgents.expects(:is_mobile_agent?).never
          @request.stubs(:params).returns({ "is_mobile" => "false" })
          assert !Schmobile::Filters.apply(@request)
        end

        should "defer to user agent check if there's no session or parameter" do
          Schmobile::UserAgents.expects(:is_mobile_agent?).once
          assert !Schmobile::Filters.apply(@request)
        end
      end

      context "on a request with mobile session set to false" do
        should "allow to change the session value with a parameter" do
          Schmobile::UserAgents.expects(:is_mobile_agent?).never
          @request.session[Schmobile::IS_MOBILE] = false
          assert !Schmobile::Filters.apply(@request)
          @request.stubs(:params).returns({ "is_mobile" => "true" })
          assert Schmobile::Filters.apply(@request)
          assert @request.session[Schmobile::IS_MOBILE]
        end
      end

      context "on a request with mobile session set to true" do
        should "allow to change the session value with a parameter" do
          Schmobile::UserAgents.expects(:is_mobile_agent?).never
          @request.session[Schmobile::IS_MOBILE] = true
          assert Schmobile::Filters.apply(@request)
          @request.stubs(:params).returns({ "is_mobile" => "false" })
          assert !Schmobile::Filters.apply(@request)
          assert !@request.session[Schmobile::IS_MOBILE]
        end
      end
    end
  end
end
