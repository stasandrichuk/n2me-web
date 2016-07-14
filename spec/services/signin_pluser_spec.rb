require 'rails_helper'

RSpec.describe SigninPluser, type: :service, broken: true do
  describe '.build' do
    it 'inits, using HTTParty' do
      expect(SigninPluser).to receive(:new).with(HTTParty).and_call_original
      expect(SigninPluser.build).to be_a(SigninPluser)
    end
  end

  describe '#call' do
    let(:user_params) { { email: 'person2@example.com', password: 'good_password' } }

    context 'remote', :vcr do
      it 'signs in pluser' do
        result = SigninPluser.build.call(user_params)

        expect(result).to be_pluser_signedin
      end

      it 'returns error' do
        result = SigninPluser.build.call(user_params.merge(password: 'bad'))

        expect(result).not_to be_pluser_signedin
        expect(result.error_message).not_to be_nil
      end
    end

    it 'handles exception from HTTParty' do
      http = double
      allow(http).to receive(:get).and_raise('Error')

      result = SigninPluser.new(http).call(user_params)

      expect(result).not_to be_pluser_signedin
      expect(result.error_message).not_to be_nil
    end

    it 'returns token' do
      http_result = double
      allow(http_result).to receive(:parsed_response).and_return('signInResponse' => { 'token' => 'MPX token' })

      http = double
      allow(http).to receive(:get).and_return(http_result)

      result = SigninPluser.new(http).call(user_params)

      expect(result.token).to eq 'MPX token'
    end
  end
end
