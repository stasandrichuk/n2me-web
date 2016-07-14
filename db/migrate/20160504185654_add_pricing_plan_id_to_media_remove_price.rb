class AddPricingPlanIdToMediaRemovePrice < ActiveRecord::Migration
  def change
    remove_column :media, :price, :integer
    add_column :media, :pricing_plan_id, :integer
  end
end
