class MediaCategory < ActiveRecord::Base
  belongs_to :medium
  belongs_to :category

  validates :medium_id, :category_id, presence: true
  validates_uniqueness_of :medium_id, scope: :category_id
end
