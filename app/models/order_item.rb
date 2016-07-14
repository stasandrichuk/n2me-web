class OrderItem < ActiveRecord::Base
  belongs_to :product
  belongs_to :order

  before_create :set_price_and_units

  private

  def set_price_and_units
    self.price = product.price
    self.subscription_unit = product.subscription_unit
  end
end
