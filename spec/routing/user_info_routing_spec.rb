require 'rails_helper'

RSpec.describe UserInfoController, type: :routing do
  describe 'routing' do
    it 'routes to #show' do
      expect(get: '/user_info').to route_to 'user_info#show'
    end
  end
end
