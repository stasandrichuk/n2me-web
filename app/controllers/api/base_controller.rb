class Api::BaseController < ApplicationController
  acts_as_token_authentication_handler_for User, fallback: :none
  skip_before_filter :verify_authenticity_token

  def pagination_dict(resources)
    {
      page: page,
      per_page: per_page,
      total_pages: resources.total_pages,
      total_count: resources.total_count
    }
  end

  def page
    params[:page] || 1
  end

  def per_page
    params[:per_page] || 25
  end
end
