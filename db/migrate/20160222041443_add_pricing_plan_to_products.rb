class AddPricingPlanToProducts < ActiveRecord::Migration
  def change
    add_column :products, :pricing_plan, :json
  end
end
