class CreateUsersStationsJoin < ActiveRecord::Migration
  def change
    create_table :users_stations, id: false do |t|
      t.integer 'user_id'
      t.integer 'station_id'
    end
    add_index :users_stations, %w(user_id station_id)
  end
end
