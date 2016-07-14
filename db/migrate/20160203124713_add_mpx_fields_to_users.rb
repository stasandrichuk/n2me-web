class AddMpxFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :mpx_token, :string
    add_column :users, :mpx_user_id, :string
  end
end
