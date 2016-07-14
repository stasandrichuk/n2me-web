class AddPricingPlanAndRemovePriceFromSubscription < ActiveRecord::Migration
  def change
    add_column :subscriptions, :pricing_plan_id, :integer
    remove_column :subscriptions, :price, :integer
  end
end
