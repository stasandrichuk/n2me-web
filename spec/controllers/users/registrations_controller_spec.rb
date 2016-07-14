require 'rails_helper'

RSpec.describe Users::RegistrationsController, type: :controller, broken: true do
  describe 'POST #create' do
    before do
      @request.env['devise.mapping'] = Devise.mappings[:user]
    end

    let(:user) { FactoryGirl.create(:user) }

    let(:params) do
      { user: { email: user.email, password: user.password, password_confirmation: user.password } }
    end

    it 'calls CreateUser service' do
      expect_any_instance_of(CreateUser).to receive(:call).with(params[:user]).and_return(user)
      post :create, params
      expect(response).to redirect_to root_url
    end
  end
end
