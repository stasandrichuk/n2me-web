require 'rails_helper'

RSpec.describe CreateOrder::CreatePaymentInstrument, type: :service, broken: true do
  describe '.build' do
    it 'inits, using ThePlatform::Data' do
      expect(CreateOrder::CreatePaymentInstrument).to receive(:new).with(HTTParty).and_call_original
      expect(CreateOrder::CreatePaymentInstrument.build).to be_a(CreateOrder::CreatePaymentInstrument)
    end
  end

  describe '#call', :vcr do
    let(:user) { FactoryGirl.build :user, mpx_token: 'M6sL5oKOD4Iooxa0TClssZBCsICYwBB8' }
    let(:credit_card) { FactoryGirl.build :credit_card }

    it 'creates instrument' do
      result = CreateOrder::CreatePaymentInstrument.build.call(user, credit_card)
      expect(result).to be_payment_instrument_created
      expect(result.id).to eq 'http://storefront.commerce.theplatform.com/storefront/data/PaymentInstrumentInfo/31742720'
    end

    it 'returns invalid token error' do
      user.mpx_token = 'bad'
      result = CreateOrder::CreatePaymentInstrument.build.call(user, credit_card)
      expect(result).not_to be_payment_instrument_created
      expect(result).to be_invalid_token
    end
  end
end
