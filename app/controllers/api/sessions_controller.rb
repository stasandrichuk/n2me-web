class Api::SessionsController < Api::BaseController
  def create
    user = User.find_by_email(params[:email])
    if user && user.valid_password?(params[:password])
      user.generate_api_authentication_token if user.authentication_token.blank?
      render json: user
    else
      render json: { errors: ['Wrong password or email address'] }, status: 401
    end
  end
end
