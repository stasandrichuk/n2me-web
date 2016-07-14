class CheckoutsController < ApplicationController
  before_action :authenticate_user!

  def create
    session[:product_ids] = params.require(:product_ids)
    redirect_to new_order_path
  end
end
