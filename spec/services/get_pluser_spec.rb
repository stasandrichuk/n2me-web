require 'rails_helper'

RSpec.describe GetPluser, type: :service, broken: true do
  describe '.build' do
    it 'inits, using HTTParty' do
      expect(GetPluser).to receive(:new).with(HTTParty).and_call_original
      expect(GetPluser.build).to be_a(GetPluser)
    end
  end

  describe '#call' do
    let(:token) { '5UgjHl8u2i78oELUHHliocCk8GDuQEBS' }

    context 'remote', :vcr do
      it 'gets pluser' do
        result = GetPluser.build.call(token)

        expect(result).to be_pluser_gotten
      end

      it 'returns error' do
        result = GetPluser.build.call('bad')

        expect(result).not_to be_pluser_gotten
        expect(result.error_message).not_to be_nil
      end
    end

    it 'handles exception from HTTParty' do
      http = double
      allow(http).to receive(:get).and_raise('Error')

      result = GetPluser.new(http).call('token')

      expect(result).not_to be_pluser_gotten
      expect(result.error_message).not_to be_nil
    end

    it 'returns details' do
      http_result = double
      details = double
      allow(http_result).to receive(:parsed_response).and_return('getSelfResponse' => details)

      http = double
      allow(http).to receive(:get).and_return(http_result)

      result = GetPluser.new(http).call('token')

      expect(result.details).to eq details
    end
  end
end
