class CreateListings < ActiveRecord::Migration
  def change
    create_table :listings do |t|
      t.string :s_number
      t.integer :channel_number
      t.integer :sub_channel_number
      t.integer :s_id
      t.string :callsign
      t.string :logo_file_name
      t.datetime :list_date_time
      t.integer :duration
      t.integer :show_id
      t.integer :series_id
      t.string :show_name
      t.string :episode_title
      t.boolean :repeat
      t.boolean :new
      t.boolean :live
      t.boolean :hd
      t.boolean :descriptive_video
      t.boolean :in_progress
      t.string :show_type
      t.integer :star_rating
      t.text :description
      t.string :league
      t.string :team1
      t.string :team2
      t.string :show_picture

      t.string :web_link
      t.string :name
      t.string :station_type
      t.integer :listing_id
      t.string :episode_number
      t.integer :parts
      t.integer :part_num
      t.boolean :series_premiere
      t.boolean :season_premiere
      t.boolean :series_finale
      t.boolean :season_finale
      t.string :rating
      t.string :guest
      t.string :director
      t.string :location

      t.string :l_id
      t.datetime :updated_date

      t.timestamps null: false
    end
  end
end
