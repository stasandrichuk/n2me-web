require 'rails_helper'

RSpec.describe CreditCard, type: :model do
  describe '#as_mpx_json' do
    it 'returns json string' do
      cc = FactoryGirl.build :credit_card
      expect(cc.as_mpx_json).to eq('properties' => {
                                     'CardNumber' => '4111111111111111',
                                     'CardName' => 'John Doe',
                                     'ExpirationYear' => '2020',
                                     'ExpirationMonth' => '01',
                                     'CardType' => 'Visa'
                                   },
                                   'billingAddress' => {
                                     'regionCode' => 'WA',
                                     'postalCode' => '18121',
                                     'countryCode' => 'US',
                                     'addressLine1' => '123 a st',
                                     'addressLine2' => '#400',
                                     'city' => 'Seattle',
                                     'fullName' => 'John Q Doe',
                                     'phoneNumber' => '1234567890'
                                   })
    end
  end

  describe '#billing_address' do
    it 'returns hash with certain fields' do
      ba = { region_code: 'IL', postal_code: '60606', country_code: 'US', address_line1: 'Addr 1', address_line2: 'Addr 2', city: 'City', full_name: 'Buba Kastorsky', phone_number: '78878888978' }
      cc = CreditCard.new(ba)
      expect(cc.billing_address).to eq ba
    end
  end

  describe '#attributes' do
    it 'returns hash with nils' do
      expect(CreditCard.new.attributes).to eq(region_code: nil, postal_code: nil, country_code: nil, address_line1: nil, address_line2: nil, city: nil, full_name: nil, phone_number: nil)
    end
  end

  describe 'validations' do
    it 'is valid' do
      expect(FactoryGirl.build(:credit_card, address_line2: '')).to be_valid
    end
  end
end
