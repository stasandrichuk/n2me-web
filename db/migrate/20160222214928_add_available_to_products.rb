class AddAvailableToProducts < ActiveRecord::Migration
  def change
    add_column :products, :available, :boolean, default: true, null: false, index: true
  end
end
