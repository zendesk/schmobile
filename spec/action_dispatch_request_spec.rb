require 'spec_helper'

if defined?(ActionDispatch::Request)
  describe ActionDispatch::Request do
    it 'respond to the schmobile helpers' do
      expect(action_dispatch_request('HTTP_USER_AGENT' => ipad)      .is_device?('ipad'))      .to be true
      expect(action_dispatch_request('HTTP_USER_AGENT' => ipad)      .is_device?('blackberry')).to be false
      expect(action_dispatch_request('HTTP_USER_AGENT' => blackberry).is_device?('blackberry')).to be true
      expect(action_dispatch_request('HTTP_USER_AGENT' => iphone)    .is_device?('blackberry')).to be false
      expect(action_dispatch_request('HTTP_USER_AGENT' => iphone)    .is_device?('iphone'))    .to be true
      expect(action_dispatch_request('HTTP_USER_AGENT' => msie6)     .is_device?('iphone'))    .to be false
    end
  end
end
