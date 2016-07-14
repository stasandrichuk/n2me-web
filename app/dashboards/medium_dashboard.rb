require 'administrate/base_dashboard'

class MediumDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    media_categories: Field::HasMany,
    categories: Field::HasMany,
    id: Field::Number,
    admin_user_id: Field::Number,
    title: Field::String,
    description: Field::Text,
    number: Field::String,
    image_url: Field::String,
    source_url: Field::String,
    extra_sources: Field::Text,
    language: Field::Select.with_options(collection: ['English', 'Español', 'Español Latinamericano', 'Français', 'Português', 'Deutsch', 'Russian', 'Italiano']),
    rating: Field::Number,
    pricing_plan: Field::BelongsTo,
    order: Field::Number,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    picture: ImageField,
    is_a_game: Field::Boolean,
    embedded_code: Field::Text,
    overlay_code: Field::Text,
    media: Field::HasMany,
    medium: Field::BelongsTo
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :id,
    :picture,
    :title,
    :categories,
    :order,
    :rating,
    :created_at,
    :updated_at
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :id,
    :picture,
    :title,
    :description,
    :categories,
    :number,
    :image_url,
    :source_url,
    :extra_sources,
    :language,
    :medium,
    :media,
    :rating,
    :order,
    :pricing_plan,
    :created_at,
    :updated_at
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :title,
    :description,
    :picture,
    :categories,
    :number,
    :image_url,
    :source_url,
    :extra_sources,
    :embedded_code,
    :overlay_code,
    :language,
    :medium,
    :media,
    :rating,
    :order,
    :pricing_plan,
    :is_a_game
  ].freeze

  # Overwrite this method to customize how media are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(medium)
    medium.title || "Medium ##{medium.id}"
  end
end
