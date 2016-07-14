class CreateFavoriteGenres < ActiveRecord::Migration
  def change
    create_table :genres do |t|
    	t.string :title
    	t.timestamps
    end
    create_table :users_genres, :id => false do |t|
    	t.integer "user_id"
    	t.integer "genre_id"  	
    end
    add_index :users_genres, ["user_id", "genre_id"]
  end
end
