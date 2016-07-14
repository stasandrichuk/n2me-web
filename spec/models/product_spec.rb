require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'relations' do
    it { is_expected.to belong_to :pricing_plan }
    it { is_expected.to have_many :product_items }
    it { is_expected.to have_many(:media).through(:product_items) }
  end

  describe 'validations' do
  end

  describe 'callbacks' do
  end

  describe 'broken', broken: true do
    let(:pricing_plan) { { 'isTaxIncluded' => false, 'isRecurring' => false, 'pricingTiers' => [{ 'absoluteStart' => 1_455_150_720_000, 'absoluteEnd' => 1_483_160_400_000, 'rightsIds' => ['http://data.entitlement.theplatform.com/eds/data/Rights/62384649'], 'subscriptionUnits' => 'month', 'billingFrequency' => 0, 'minimumSubscriptionPeriod' => 0, 'productTagIds' => [], 'productTags' => [], 'amounts' => { 'USD' => 14.99 }, 'isBlackout' => false, 'isActive' => true }], 'masterAgreementStartDate' => 1_455_080_400_000, 'masterAgreementEndDate' => 1_483_160_400_000, 'masterProductTagIds' => [] } }
    let(:product) { Product.new pricing_plan: pricing_plan }

    describe '#price' do
      it 'returns active price' do
        expect(product.price).to eq 14.99
      end

      it 'returns 0' do
        expect(Product.new.price).to eq 0
      end
    end

    describe '#subscription_unit' do
      it 'returns month' do
        expect(product.subscription_unit).to eq 'month'
      end
    end
  end
end
