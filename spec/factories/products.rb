FactoryGirl.define do
  factory :product do
    title 'Title'
    description 'Description'
    pricing_plan JSON.parse('{"isTaxIncluded":false,"isRecurring":false,"pricingTiers":[{"absoluteStart":1455151920000,"absoluteEnd":1483160400000,"rightsIds":["http://data.entitlement.theplatform.com/eds/data/Rights/62384649"],"subscriptionUnits":"month","billingFrequency":0,"minimumSubscriptionPeriod":0,"productTagIds":[],"productTags":[],"amounts":{"USD":14.99},"isBlackout":false,"isActive":true}],"masterAgreementStartDate":1455080400000,"masterAgreementEndDate":1483160400000,"masterProductTagIds":[]}')
  end
end
