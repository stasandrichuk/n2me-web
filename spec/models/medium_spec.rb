require 'rails_helper'

RSpec.describe Medium, type: :model do
  describe 'relations' do
    it { is_expected.to have_many(:media_categories).dependent(:destroy) }
    it { is_expected.to have_many(:categories).through(:media_categories) }
    it { is_expected.to belong_to :pricing_plan }
    it { is_expected.to belong_to :medium }
    it { is_expected.to have_many :media }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of :title }
  end
end
