class AddImageToMediaAndCategories < ActiveRecord::Migration
  def change
    add_column :categories, :image, :string
    add_column :media, :image, :string
  end
end
