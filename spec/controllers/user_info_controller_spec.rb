require 'rails_helper'

RSpec.describe UserInfoController, type: :controller do
  let(:user) { create :user }
  let(:json) { JSON.parse response.body }
  before(:each) { sign_in user }
  describe 'GET /user_info' do
    let(:result) { json['result'] }
    subject { get :show }
    it 'requires authentication' do
      sign_out user
      subject
      expect(response).to redirect_to new_user_session_path
    end

    it 'returns ok=1' do
      subject
      expect(json['ok']).to eq 1
    end

    it 'returns user email as result' do
      subject
      expect(result['email']).to eq user.email
    end
  end
end
