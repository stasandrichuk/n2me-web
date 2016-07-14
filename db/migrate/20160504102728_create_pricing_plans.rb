class CreatePricingPlans < ActiveRecord::Migration
  def change
    create_table :pricing_plans do |t|
      t.string :title
      t.integer :price, default: 99
      t.string :interval, default: 'month'
      t.integer :interval_count, default: 1
      t.integer :trial_period_days, default: 0
      t.string :unique_key, unique: true
      t.string :stripe_id

      t.timestamps null: false
    end
  end
end
