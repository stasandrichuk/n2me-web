class AddRecentlyViewedMediaToUsers < ActiveRecord::Migration
  def change
    add_column :users, :recently_viewed_media_ids, :text, array: true, default: []
  end
end
