class AddIsAGameToMedia < ActiveRecord::Migration
  def change
    add_column :media, :is_a_game, :boolean, default: false
  end
end
