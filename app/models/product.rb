class Product < ActiveRecord::Base
  belongs_to :pricing_plan
  has_many :product_items

  has_many :media, through: :product_items, source: :item, source_type: Medium
  has_many :categories, through: :product_items, source: :item, source_type: Category

  default_scope { where(available: true) }

  mount_uploader :picture, PictureUploader, mount_on: :image

  validates :title, :pricing_plan, presence: true
  validate :any_item_included

  def price
    pricing_plan.price / 100.00
  end

  def self.basic_plan
    where(pricing_plan_id: nil)
  end

  private

  def any_item_included
    return if media.any? || categories.any?
    errors.add(:base, 'Please add at least one media or category')
  end
end
