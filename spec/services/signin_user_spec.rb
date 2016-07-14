require 'rails_helper'

RSpec.describe SigninUser, type: :service do
  describe '.build' do
    it 'inits, using SigninPluser, GetPluser' do
      expect(SigninUser).to receive(:new).with(SigninPluser, GetPluser).and_call_original
      expect(SigninUser.build).to be_a(SigninUser)
    end
  end

  describe '#call' do
    let(:user) { FactoryGirl.create(:user) }
    let(:params) { { email: user.email, password: user.password } }
    let(:signin_pluser) { double }
    let(:get_pluser) { double }
    let(:get_pluser) { double }
    let(:mpx_token) { 'MPX-token' }
    let(:result) { double(pluser_signedin?: true, token: mpx_token) }

    subject { SigninUser.new(signin_pluser, get_pluser).call(params, user) }

    before do
      allow(get_pluser).to receive(:call).and_return(double(pluser_gotten?: false, error_message: 'Err'))
    end

    context 'user does not have token' do
      it 'signin pluser' do
        expect(signin_pluser).to receive(:call).with(params).and_return(result)
        subject
      end

      it 'saves token' do
        allow(signin_pluser).to receive(:call).with(params).and_return(result)
        expect(subject).to be_user_signedin
        expect(user.mpx_token).to eq mpx_token
      end
    end

    context 'user already has token' do
      before { user.mpx_token = 'MPX-existent-token' }

      it 'checks token' do
        allow(signin_pluser).to receive(:call).and_return(result)

        expect(get_pluser).to receive(:call).with(user.mpx_token).and_return(double(pluser_gotten?: true))

        subject
      end

      it 'signs in pluser if token invalid' do
        allow(get_pluser).to receive(:call).and_return(double(pluser_gotten?: false, error_message: 'Error'))

        expect(signin_pluser).to receive(:call).with(params).and_return(result)

        subject
      end
    end
  end
end
