class CreateProductItems < ActiveRecord::Migration
  def change
    create_table :product_items do |t|
      t.references :product, index: true, null: false
      t.string :mpxid, index: true, null: false
      t.string :title
      t.string :description

      t.timestamps null: false
    end
  end
end
