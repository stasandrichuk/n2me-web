class Medium < ActiveRecord::Base
  has_many :media_categories, dependent: :destroy
  has_many :categories, through: :media_categories

  belongs_to :pricing_plan
  belongs_to :medium
  has_many :media

  mount_uploader :picture, PictureUploader, mount_on: :image

  validates :title, presence: true
  validate :has_or_belongs_to_language_group

  def self.languages
    select('distinct language').where("language is not null and language <> ''").map(&:language).sort { |x, y| x <=> y }
  end

  def languages
    @_languages ||= if medium_id.present?
                      Media.where('medium_id = :id OR id = :id', id: medium_id)
                    else
                      [self].concat media
                    end
  end

  def product_ids
    prduct_ids = ProductItem.where(item_type: 'Medium', item_id: id).map(&:product_id).compact.uniq
    return prduct_ids if prduct_ids.present?
    category_ids = categories.map(&:id)
    prduct_ids = ProductItem.where(item_type: 'Category', item_id: category_ids).map(&:product_id).compact.uniq
    return prduct_ids if prduct_ids.present?
    return ["a#{id}"] if pricing_plan.present?
    []
  end

  def price
    pricing_plan.price / 100.00
  end

  def language_list
    return medium.language_list if medium_id.present?
    list = [language] + media.map(&:language)
    list.join.blank? ? ['English'] : list.join(' | ')
  end

  # mpx compatibility
  def thumbnail_url
    picture.present? ? picture_url : image_url
  end

  def file_url
    source_url
  end

  def category_name
    categories.first.try(:title) || 'TV'
  end

  def thumbnails
    [thumbnail_url]
  end

  def overlay
    overlay_code
  end

  def overlay_link
  end

  def self.basic_plan_media
    category_ids = ProductItem.where(item_type: 'Category').map(&:item_id)
    media_ids = ProductItem.where(item_type: 'Medium').map(&:item_id)
    includes(:media_categories).where(pricing_plan_id: nil)
                               .where.not('media.id' => media_ids, 'media_categories.category_id' => category_ids)
  end

  def related_items
    items = []
    categories.each do |cat|
      item = items.concat( cat.media.where.not(:id => self.id) )
    end
    items.uniq[0...50]
  end

  def related_items
    items = []
    categories.each do |cat|
      item = items.concat( cat.media.where.not(:id => self.id) )
    end
    items.uniq[0...50]
  end

  private

  def has_or_belongs_to_language_group
    if medium_id.present? && media.any?
      errors.add(:base, "Media can't have languages and belong to other media at same time")
    end
  end
end
# alias
class Media < Medium; end
