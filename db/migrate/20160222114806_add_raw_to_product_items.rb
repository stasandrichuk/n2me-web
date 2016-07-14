class AddRawToProductItems < ActiveRecord::Migration
  def change
    add_column :product_items, :raw, :json
  end
end
