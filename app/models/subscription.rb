class Subscription < ActiveRecord::Base
  before_create :create_stripe_subscription

  belongs_to :user
  belongs_to :product
  belongs_to :pricing_plan

  has_many :subscription_items
  has_many :media, through: :subscription_items, source: :item, source_type: Medium
  has_many :categories, through: :subscription_items, source: :item, source_type: Category

  has_one :payment_detail

  private

  def create_stripe_subscription
  end
end
