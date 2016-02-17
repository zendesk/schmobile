require 'spec_helper'

describe Schmobile::Filters do
  let(:session) { {} }
  let(:params)  { {} }
  let(:request) { double('Request', user_agent: msie8, params: params, session: session) }

  describe '#apply' do
    describe 'on a pristine request' do
      it 'returns true if the session is already mobile' do
        expect(Schmobile::UserAgents).to_not receive(:is_mobile_agent?)
        session[Schmobile::IS_MOBILE] = true
        expect(Schmobile::Filters.apply(request)).to be true
      end

      it "returns true if there's an is_mobile parameter with value true" do
        expect(Schmobile::UserAgents).to_not receive(:is_mobile_agent?)
        params.merge!('is_mobile' => 'true')
        expect(Schmobile::Filters.apply(request)).to be true
      end

      it "returns false if there's an is_mobile parameter with value false" do
        expect(Schmobile::UserAgents).to_not receive(:is_mobile_agent?)
        params.merge!('is_mobile' => 'false')
        expect(Schmobile::Filters.apply(request)).to be false
      end

      it "defers to user agent check if there's no session or parameter" do
        expect(Schmobile::UserAgents).to receive(:is_mobile_agent?).once
        expect(Schmobile::Filters.apply(request)).to be false
      end
    end

    describe 'on a request with mobile session set to false' do
      it 'allows to change the session value with a parameter' do
        expect(Schmobile::UserAgents).to_not receive(:is_mobile_agent?)
        session[Schmobile::IS_MOBILE] = false
        expect(Schmobile::Filters.apply(request)).to be false
        params.merge!('is_mobile' => 'true')
        expect(Schmobile::Filters.apply(request)).to be true
        expect(request.session[Schmobile::IS_MOBILE]).to be true
      end
    end

    describe 'on a request with mobile session set to true' do
      it 'allows to change the session value with a parameter' do
        expect(Schmobile::UserAgents).to_not receive(:is_mobile_agent?)
        session[Schmobile::IS_MOBILE] = true
        expect(Schmobile::Filters.apply(request)).to be true
        params.merge!('is_mobile' => 'false')
        expect(Schmobile::Filters.apply(request)).to be false
        expect(request.session[Schmobile::IS_MOBILE]).to be false
      end
    end
  end
end
