class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :title
      t.text :description
      t.integer :order, default: 0
      t.integer :category_id, index: true
      t.string :image_url
      t.string :number, index: true

      t.timestamps null: false
    end
  end
end
