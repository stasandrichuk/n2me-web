class UpdateFavoriteMediaChangeMediaNumberType < ActiveRecord::Migration
  def change
  	change_column :favorite_media, :media_number, :string
  end
end
