class RemoveUselessFieldsFromProductItems < ActiveRecord::Migration
  def change
    remove_column :product_items, :mpxid, :string
    remove_column :product_items, :title, :string
    remove_column :product_items, :description, :string
    remove_column :product_items, :raw, :json
  end
end
