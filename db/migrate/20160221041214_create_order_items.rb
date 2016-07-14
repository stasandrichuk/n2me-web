class CreateOrderItems < ActiveRecord::Migration
  def change
    create_table :order_items do |t|
      t.references :product, null: false
      t.references :order, null: false
      t.decimal :price
      t.string :subscription_unit

      t.timestamps null: false
    end

    add_index :order_items, [:order_id, :product_id], unique: true
  end
end
