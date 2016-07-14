class AddMediumIdToMedia < ActiveRecord::Migration
  def change
    add_column :media, :medium_id, :integer
  end
end
