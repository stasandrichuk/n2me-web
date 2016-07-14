class UpdateUserAddDefaultLanguage < ActiveRecord::Migration
  def change
    add_column :users, :default_language, :string, default: 'English'
  end
end
