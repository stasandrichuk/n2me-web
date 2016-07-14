class CreateFavoriteMedia < ActiveRecord::Migration
  def change
    create_table :favorite_media do |t|
      t.integer :user_id, index: true
      t.integer :media_number, index: true

      t.timestamps null: false
    end
  end
end
