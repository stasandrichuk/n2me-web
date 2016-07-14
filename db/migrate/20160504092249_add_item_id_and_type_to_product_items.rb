class AddItemIdAndTypeToProductItems < ActiveRecord::Migration
  def change
    add_column :product_items, :item_id, :integer, index: true
    add_column :product_items, :item_type, :string, index: true
  end
end
