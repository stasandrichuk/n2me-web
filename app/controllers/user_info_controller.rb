class UserInfoController < ApplicationController
  before_filter :authenticate_user!

  def show
    render json: {
      ok: 1,
      result: {
        email: current_user.email
      }
    }
  end
end
