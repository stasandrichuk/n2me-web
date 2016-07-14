class SearchController < ApplicationController
  layout 'new_layout'

  def index
    @found_media = Medium.where('title @@ ? OR title ILIKE ?', params[:q], "%#{params[:q]}%")
                         .page(params[:page])
  end
end
