require 'spec_helper'

describe Schmobile::Middleware do
  before do
    @app  = Class.new { def call(app); true; end }.new
    @rack = Schmobile::Middleware.new(@app)
  end

  it 'returns an HTTP permanent redirect when given a redirect path and used by a mobile client' do
    @rack = Schmobile::Middleware.new(@app, redirect_to: '/hello')
    expect_any_instance_of(Rack::Request).to receive(:is_mobile?).and_return(true)

    expect(@rack.call(environment)).to eq(
      [
        301,
        { 'Location'=>'/hello' },
        []
      ]
    )
  end

  describe 'with no redirect_to' do
    it 'does not redirect mobile traffic' do
      expect_any_instance_of(Rack::Request).to receive(:params).and_return({})
      expect(@app).to receive(:call)
      @rack.call(environment('HTTP_USER_AGENT' => iphone))
    end

    it 'queries the request object to determine if this is a mobile request' do
      expect_any_instance_of(Rack::Request).to receive(:is_mobile?).and_return(true)
      @rack.call(environment('HTTP_USER_AGENT' => iphone))
    end
  end

  describe 'with redirect_to' do
    before do
      @rack = Schmobile::Middleware.new(@app, redirect_to: '/wonderland')
    end

    describe '#redirect?' do
      it 'returns true when not on mobile path' do
        expect(@rack.redirect?(request('PATH_INFO' => '/somewhere'))).to be true
      end

      it 'returns true on base path' do
        expect(@rack.redirect?(request('PATH_INFO' => '/'))).to be true
      end

      it 'returns false when already on path' do
        expect(@rack.redirect?(request('PATH_INFO' => '/wonderland'))).to be false
        expect(@rack.redirect?(request('PATH_INFO' => '/wonderland/more/stuff'))).to be false
      end

      it 'returns false when :if resolves to false' do
        @rack = Schmobile::Middleware.new(@app, redirect_to: '/wonderland', redirect_if: Proc.new { |request| false })
        expect(@rack.redirect?(request('PATH_INFO' => '/somewhere'))).to be false
      end
    end

    describe '#redirect' do
      it 'interpolates the argument string xxxx' do
        @rack = Schmobile::Middleware.new(@app, redirect_to: '/wonderland', redirect_with: '/{{path}}')
        expect(@rack.redirect_location(request('PATH_INFO' => 'wiffle'))).to eq('/wonderland/wiffle')
      end

      it 'interpolates a multipart argument string' do
        @rack = Schmobile::Middleware.new(@app, redirect_to: '/wonderland/', redirect_with: '{{path}}/lemurs/{{path}}')
        expect(@rack.redirect_location(request('PATH_INFO' => 'wiffle'))).to eq('/wonderland/wiffle/lemurs/wiffle')
      end
    end
  end
end
