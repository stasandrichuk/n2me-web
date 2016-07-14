class FavoriteMedium < ActiveRecord::Base
  validates :user_id, :media_number, presence: true
  validates_uniqueness_of :media_number, scope: :user_id
end
