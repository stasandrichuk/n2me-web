require 'rails_helper'

RSpec.describe CreateUser, type: :service, broken: true do
  describe '.build' do
    it 'inits, building CreatePluser, SigninPluser' do
      expect(CreateUser::CreatePluser).to receive(:build)
      expect(SigninPluser).to receive(:build)
      expect(CreateUser.build).to be_a(CreateUser)
    end
  end

  describe '#call' do
    let(:user) { FactoryGirl.build :user }
    let(:params) { { email: user.email, password: user.password, password_confirmation: user.password } }
    let(:create_pluser) { double }
    let(:signin_pluser) { double }
    let(:mpx_user_id) { 'userID-123' }
    let(:mpx_user_token) { 'MPX-token' }
    let(:success_result) { double(pluser_created?: true, id: mpx_user_id) }
    let(:error_message) { 'Error Message' }
    let(:failed_result) { double(pluser_created?: false, error_message: error_message) }
    let(:signin_result) { double(pluser_signedin?: true, token: mpx_user_token) }
    subject { CreateUser.new(create_pluser, signin_pluser).call(params) }

    before do
      allow(User).to receive(:new).and_return(user)
      allow(user).to receive(:valid?).and_return(true)
      allow(create_pluser).to receive(:call).and_return(success_result)
      allow(signin_pluser).to receive(:call).and_return(signin_result)
      allow(user).to receive(:save).and_return(true)
    end

    it 'returns user' do
      allow(user).to receive(:valid?).and_return(false)
      expect(subject).to eq user
    end

    it 'validates' do
      expect(User).to receive(:new).with(params).and_return(user)
      expect(user).to receive(:valid?).and_return(true)
      subject
    end

    it 'calls CreatePluser' do
      expect(create_pluser).to receive(:call).with(user).and_return(success_result)
      subject
    end

    it 'saves' do
      expect(user).to receive(:save).and_return(true)
      subject
    end

    it 'assigns mpx id' do
      expect(subject.mpx_user_id).to eq mpx_user_id
    end

    it 'signs in pluser' do
      expect(signin_pluser).to receive(:call).with(params.slice(:email, :password)).and_return(signin_result)
      subject
    end

    it 'assigns mpx token' do
      expect(subject.mpx_token).to eq mpx_user_token
    end

    context 'invalid' do
      it 'does not call create_pluser' do
        allow(user).to receive(:valid?).and_return(false)
        expect(create_pluser).not_to receive(:call)
        subject
      end

      it 'does not save' do
        allow(user).to receive(:valid?).and_return(false)
        expect(user).not_to receive(:save)
        subject
      end
    end

    context 'error on create_pluser' do
      it 'does not save' do
        allow(create_pluser).to receive(:call).and_return(failed_result)
        expect(user).not_to receive(:save)
        subject
      end

      it 'adds error message' do
        allow(create_pluser).to receive(:call).and_return(failed_result)
        expect(user).not_to receive(:save)
        expect(subject.errors[:base]).to eq [error_message]
      end
    end
  end
end
