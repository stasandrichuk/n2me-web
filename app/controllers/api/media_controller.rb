class Api::MediaController < Api::BaseController
  def index
    media = Medium.includes(:categories, :media)
                  .order('media.order DESC')
                  .page(page)
                  .per(per_page)
    render json: media, meta: pagination_dict(media)
  end

  def show
    medium = Medium.where('id = :id OR number = :id', id: params[:id])
    if medium.present?
      render json: medium
    else
      render json: { errors: 'Media not found' }, status: 404
    end
  end
end
