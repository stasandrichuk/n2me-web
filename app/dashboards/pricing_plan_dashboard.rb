require 'administrate/base_dashboard'

class PricingPlanDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    products: Field::HasMany,
    id: Field::Number,
    title: Field::String,
    price: Field::Number,
    interval: Field::Select.with_options(collection: %w(day month week year)),
    interval_count: Field::Number,
    trial_period_days: Field::Number,
    unique_key: Field::String,
    stripe_id: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :id,
    :title,
    :price,
    :products
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :id,
    :title,
    :price,
    :interval,
    :interval_count,
    :trial_period_days,
    :stripe_id,
    :products,
    :created_at,
    :updated_at
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :title,
    :price,
    :interval,
    :interval_count,
    :trial_period_days
  ].freeze

  # Overwrite this method to customize how pricing plans are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(pricing_plan)
    "#{pricing_plan.title} ID##{pricing_plan.id}"
  end
end
