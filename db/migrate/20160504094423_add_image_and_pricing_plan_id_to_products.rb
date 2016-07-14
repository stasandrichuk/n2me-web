class AddImageAndPricingPlanIdToProducts < ActiveRecord::Migration
  def change
    add_column :products, :image, :string
    add_column :products, :pricing_plan_id, :integer
  end
end
