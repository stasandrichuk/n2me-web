class CreatePaymentDetails < ActiveRecord::Migration
  def change
    create_table :payment_details do |t|
      t.integer :user_id
      t.string :card_number
      t.string :card_type
      t.string :stripe_customer_id

      t.timestamps null: false
    end
  end
end
