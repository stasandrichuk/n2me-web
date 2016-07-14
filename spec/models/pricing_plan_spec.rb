require 'rails_helper'

RSpec.describe PricingPlan, type: :model do
  describe 'relations' do
    it { is_expected.to have_many :products }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of :title }
    it { is_expected.to validate_presence_of :interval }
    it { is_expected.to validate_presence_of :price }
    it { is_expected.to validate_numericality_of(:price).is_greater_than(0) }
    it do
      is_expected.to validate_numericality_of(:interval_count)
        .is_greater_than(0)
    end
    it do
      is_expected.to validate_numericality_of(:trial_period_days)
        .is_greater_than(0)
    end
  end

  describe 'callbacks' do
    it { is_expected.to callback(:create_unique_key).before(:create) }
    it { is_expected.to callback(:create_stripe_plan).after(:create) }
    it { is_expected.to callback(:update_stripe_plan).before(:update) }
  end
end
