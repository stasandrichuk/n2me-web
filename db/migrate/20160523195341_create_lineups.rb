class CreateLineups < ActiveRecord::Migration
  def change
    create_table :lineups do |t|
      t.string :l_id
      t.string :lineup_name
      t.string :lineup_type
      t.string :provider_id
      t.string :provider_name
      t.string :service_area
      t.string :country

      t.timestamps null: false
    end
  end
end
