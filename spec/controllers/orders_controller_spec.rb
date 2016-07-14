require 'rails_helper'

RSpec.describe OrdersController, type: :controller, broken: true do
  describe 'GET #new' do
    context 'user signed in' do
      before do
        sign_in FactoryGirl.create(:user)
      end

      context 'valid token' do
        before do
          allow_any_instance_of(GetPluser).to receive(:call).and_return(double(pluser_gotten?: true))
        end

        it 'is ok' do
          session[:product_ids] = [1, 2, 3]
          get :new
          expect(response).to be_ok
        end

        it 'redirects if cart is empty' do
          get :new
          expect(response).to redirect_to(root_url)
        end
      end

      it 'redirects to sign in form if token is invalid' do
        allow_any_instance_of(GetPluser).to receive(:call).and_return(double(pluser_gotten?: false))
        get :new
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end
end
