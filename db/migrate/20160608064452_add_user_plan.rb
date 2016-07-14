class AddUserPlan < ActiveRecord::Migration
  def change
    add_column :users, :start_trial_date, :datetime
  end
end
