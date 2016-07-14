class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.references :user, null: false, index: true
      t.string :mpxid

      t.timestamps null: false
    end
  end
end
