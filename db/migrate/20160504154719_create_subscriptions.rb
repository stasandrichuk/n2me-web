class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.integer :user_id
      t.string  :price
      t.string  :billing_period
      t.integer :product_id
      t.string  :payment_detail_id
      t.string  :stripe_id
      t.string  :stripe_plan_id

      t.timestamps null: false
    end
  end
end
