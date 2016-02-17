require 'spec_helper'

describe Schmobile::Request do
  describe '#is_device?' do
    it 'matchs devices as part of the user agent case insensitively' do
      expect(request('HTTP_USER_AGENT' => ipad)      .is_device?('ipad'))      .to be true
      expect(request('HTTP_USER_AGENT' => ipad)      .is_device?('blackberry')).to be false
      expect(request('HTTP_USER_AGENT' => blackberry).is_device?('blackberry')).to be true
      expect(request('HTTP_USER_AGENT' => iphone)    .is_device?('blackberry')).to be false
      expect(request('HTTP_USER_AGENT' => iphone)    .is_device?('iphone'))    .to be true
      expect(request('HTTP_USER_AGENT' => msie6)     .is_device?('iphone'))    .to be false
    end
  end

  describe '#is_mobile?' do
    it 'only calls the filter chain once' do
      expect(Schmobile::Filters).to receive(:apply).once.and_return(false)
      one_request = request
      3.times { one_request.is_mobile? }
    end

    it 're-calls the filter chain once reset' do
      expect(Schmobile::Filters).to receive(:apply).twice.and_return(false)
      one_request = request
      3.times { one_request.is_mobile? }
      one_request.toggle_mobile_session!
      3.times { one_request.is_mobile? }
    end

    describe 'without params' do
      before do
        allow_any_instance_of(Rack::Request).to receive(:params).and_return({})
      end

      it 'does not detect a regular browser as mobile' do
        expect(request.is_mobile?).to be false
        expect(request('HTTP_USER_AGENT' => nil).is_mobile?).to be false

        [ :msie6, :msie8, :opera, :chrome ].each do |browser|
          agent = self.send(browser)
          expect(request('HTTP_USER_AGENT' => agent).is_mobile?).to be false
        end
      end

      it 'detects mobile units as mobile' do
        [ :ipod, :iphone, :android, :blackberry, :samsung, :palm, :htc_touch, :danger ].each do |phone|
          agent = self.send(phone)
          expect(request('HTTP_USER_AGENT' => agent).is_mobile?).to be true
        end
      end

      it 'not detects an ipad as a mobile browser' do
        expect(request('HTTP_USER_AGENT' => ipad).is_mobile?).to be false
      end

      it 'returns false when forced in the session' do
        allow_any_instance_of(Rack::Request).to receive(:session).and_return({ Schmobile::IS_MOBILE => false })
        expect(request('HTTP_USER_AGENT' => iphone).is_mobile?).to be false
      end

      it 'returns true when forced in the session' do
        allow_any_instance_of(Rack::Request).to receive(:session).and_return({ Schmobile::IS_MOBILE => true })
        expect(request.is_mobile?).to be true
      end
    end

    describe 'with params' do
      it 'returns false when forced via a request parameter' do
        allow_any_instance_of(Rack::Request).to receive(:params).and_return({ Schmobile::IS_MOBILE => 'false' })
        expect(request('HTTP_USER_AGENT' => iphone).is_mobile?).to be false
      end

      it 'returns true when forced via a request parameter' do
        allow_any_instance_of(Rack::Request).to receive(:params).and_return({ Schmobile::IS_MOBILE => 'true' })
        expect(request.is_mobile?).to be true
      end
    end
  end
end
