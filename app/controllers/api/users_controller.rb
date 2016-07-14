class Api::UsersController < Api::BaseController
  def show
    if current_user.present?
      render json: current_user
    else
      render json: { errors: ['Please provide correct authentication'] }, status: 401
    end
  end
end
