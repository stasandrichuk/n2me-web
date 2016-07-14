class CreateMedia < ActiveRecord::Migration
  def change
    create_table :media do |t|
      t.integer :admin_user_id
      t.string :title
      t.text :description
      t.string :number, index: true
      t.string :image_url
      t.string :source_url
      t.text :extra_sources
      t.string :language
      t.integer :rating, default: 0
      t.integer :price, default: 99
      t.integer :order, default: 0
      t.text :embedded_code, :text
      t.text :overlay_code, :text

      t.timestamps null: false
    end
  end
end
