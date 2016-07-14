require 'rails_helper'

RSpec.describe CreateUser::CreatePluser, type: :service, broken: true do
  describe '.build' do
    it 'inits, using ThePlatform::Data' do
      expect(CreateUser::CreatePluser).to receive(:new).with(ThePlatform::Data).and_call_original
      expect(CreateUser::CreatePluser.build).to be_a(CreateUser::CreatePluser)
    end
  end

  describe '#call', :vcr do
    let(:user) { FactoryGirl.build :user }

    it 'creates pluser' do
      result = CreateUser::CreatePluser.build.call(user)
      expect(result).to be_pluser_created
      expect(result.id).to eq 'https://euid.theplatform.com/idm/data/User/UBpRu2vqlRVlcA0H/244111143'
    end

    it 'returns error' do
      user.email = ''
      result = CreateUser::CreatePluser.build.call(user)
      expect(result).not_to be_pluser_created
      expect(result.error_message).not_to be_nil
    end

    it 'handles exception' do
      tpdata = double
      allow(tpdata).to receive(:euid).and_raise('Error')
      result = CreateUser::CreatePluser.new(tpdata).call(user)
      expect(result).not_to be_pluser_created
      expect(result.error_message).not_to be_nil
    end
  end
end
