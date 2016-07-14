FactoryGirl.define do
  factory :credit_card do
    skip_create
    card_number '4111111111111111'
    card_name 'John Doe'
    expiration_year '2020'
    expiration_month '01'
    card_type 'Visa'
    region_code 'WA'
    postal_code '18121'
    country_code 'US'
    address_line1 '123 a st'
    address_line2 '#400'
    city 'Seattle'
    full_name 'John Q Doe'
    phone_number '1234567890'
  end
end
