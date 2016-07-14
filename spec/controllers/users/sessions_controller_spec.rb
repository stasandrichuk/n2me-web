require 'rails_helper'

RSpec.describe Users::SessionsController, type: :controller, broken: true do
  render_views

  describe 'POST #create' do
    before do
      @request.env['devise.mapping'] = Devise.mappings[:user]
    end

    let(:user) { FactoryGirl.create(:user) }

    let(:params) do
      { user: { email: user.email, password: user.password } }
    end

    it 'calls SigninUser' do
      expect_any_instance_of(SigninUser).to receive(:call).with(params[:user], user)
        .and_return(double(user_signedin?: true))
      post :create, params
      expect(response).to redirect_to root_url
    end

    it 'signs out if user signin failed' do
      allow_any_instance_of(SigninUser).to receive(:call)
        .and_return(double(user_signedin?: false, error_message: 'Faild login to MPX'))

      post :create, params

      expect(response).to redirect_to new_user_session_url
    end
  end
end
