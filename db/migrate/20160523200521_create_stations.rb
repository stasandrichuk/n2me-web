class CreateStations < ActiveRecord::Migration
  def change
    create_table :stations do |t|
      t.string :s_number
      t.integer :channel_number
      t.integer :sub_channel_number
      t.integer :s_id
      t.string :name
      t.string :callsign
      t.string :network
      t.string :station_type
      t.integer :ntsc_tsid
      t.integer :dtv_tsid
      t.string :twitter
      t.string :weblink
      t.string :logo_file_name
      t.boolean :station_hd

      t.timestamps null: false
    end
  end
end
