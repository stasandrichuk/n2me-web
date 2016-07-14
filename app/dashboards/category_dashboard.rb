require 'administrate/base_dashboard'

class CategoryDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    media_categories: Field::HasMany,
    media: Field::HasMany.with_options(class_name: 'Media'),
    id: Field::Number,
    title: Field::String,
    description: Field::Text,
    order: Field::Number,
    category: Field::BelongsTo,
    image_url: Field::String,
    picture: ImageField,
    number: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    categories: Field::HasMany.with_options(label: 'Roles')
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
    :order
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :id,
    :title,
    :picture,
    :description,
    :order,
    :category,
    :image_url,
    :number,
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
    :order,
    :category,
    :categories,
    :image_url,
    :number
  ].freeze

  # Overwrite this method to customize how categories are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(category)
    category.title || "Category ##{category.id}"
  end
end
