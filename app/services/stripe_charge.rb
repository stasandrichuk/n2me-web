class StripeCharge
  attr_accessor :charge_created, :error

  def self.create(user:, amount:, token:)
    new(user, amount, token)
  end

  def initialize(user, amount, token)
    charge = perform_stripe_charge(user, amount, token)
    create_transaction(user, charge) if created?
  end

  def created?
    charge_created
  end

  def perform_stripe_charge(user, amount, token)
    charge = Stripe::Charge.create(
      amount: amount,
      currency: 'usd',
      source: token,
      description: "Subscription on N2me.TV (#{user.email})"
    )
    self.charge_created = true
  rescue Exception => ex
    self.error = ex.message
    self.charge_created = false
  end

  def create_transaction(user, charge)
    # TODO: create transaction record here (create model as well)
  end
end
