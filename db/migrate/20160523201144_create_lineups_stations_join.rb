class CreateLineupsStationsJoin < ActiveRecord::Migration
  def change
    create_table :lineups_stations, id: false do |t|
      t.integer 'lineup_id'
      t.integer 'station_id'
    end
    add_index :lineups_stations, %w(lineup_id station_id)
  end
end
