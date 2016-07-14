class FavoriteMediaController < ApplicationController
  def create
    fm = FavoriteMedium.create(media_number: params[:media_number],
                               user_id: current_user.id)
    redirect_to :back
  end

  def destroy
    FavoriteMedium.find_by(media_number: params[:id],
                           user_id: current_user.id)
                  .try(:destroy)
    redirect_to :back
  end
end
