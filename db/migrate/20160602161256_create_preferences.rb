class CreatePreferences < ActiveRecord::Migration
  def change
    create_table :preferences do |t|
      t.string :initial_time
      t.string :station_filter
      t.integer :time_span
      t.integer :grid_height
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
