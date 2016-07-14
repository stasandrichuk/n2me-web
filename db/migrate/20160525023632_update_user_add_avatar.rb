class UpdateUserAddAvatar < ActiveRecord::Migration
  def change
    add_column :users, :avatar, :string
    add_column :users, :avatar_option, :integer, default: 0
  end
end
