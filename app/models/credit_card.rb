class CreditCard
  include ActiveModel::Model
  include ActiveModel::AttributeMethods
  include ActiveModel::Validations
  include ActiveModel::Serialization

  BILLING_ADDRESS_KEYS = [:region_code, :postal_code, :country_code, :address_line1, :address_line2,
                          :city, :full_name, :phone_number].freeze
  CARD_KEYS = [:card_number, :card_name, :expiration_year, :expiration_month, :card_type].freeze

  attr_accessor *CARD_KEYS
  attr_accessor *BILLING_ADDRESS_KEYS

  validates *CARD_KEYS, presence: true
  validates *(BILLING_ADDRESS_KEYS - [:address_line2]), presence: true

  def as_mpx_json
    { 'properties' => mpx_attributes(true, *CARD_KEYS),
      'billingAddress' => mpx_attributes(false, *BILLING_ADDRESS_KEYS) }
  end

  def billing_address
    serializable_hash
  end

  def attributes
    BILLING_ADDRESS_KEYS.map { |k| [k, nil] }.to_h
  end

  private

  def mpx_attributes(first_upper, *keys)
    keys.inject({}) do |res, key|
      res.merge(key.to_s.camelize(first_upper ? :upper : :lower) => send(key))
    end
  end
end
