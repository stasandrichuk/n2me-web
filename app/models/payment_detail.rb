class PaymentDetail < ActiveRecord::Base
  before_create :create_stripe_customer

  belongs_to :user

  attr_accessor :stripe_token

  private

  def create_stripe_customer
    customer = Stripe::Customer.create(
      description: "Customer #{user.name} #{user.email} ID #{user_id}",
      source: stripe_token
    )
    self.stripe_customer_id = customer.id
  end
end
