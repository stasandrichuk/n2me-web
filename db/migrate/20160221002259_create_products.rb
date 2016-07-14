class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :mpxid, index: true, null: false
      t.string :title
      t.string :description
      t.string :images, array: true, default: []

      t.timestamps null: false
    end
  end
end
