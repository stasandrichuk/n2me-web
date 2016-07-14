class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :load_categories, except: :not_found
  before_action :detect_browser
  before_action :enforce_ssl_if_needed
  before_action :set_language

  def https
    'https://'
  end

  def enforce_ssl_if_needed
    if Rails.env == 'production' && request.protocol == 'http://' && (controller_name == 'registrations' || controller_name == 'sessions')
      redirect_to protocol: https
    end

    true
  end

  def load_categories
    @search_categories = [] # MPX::Category.all
    @root_categories = [] # MPX::Category.root_categories
  end

  def not_found
    render inline: 'Page not found', status: 404
  end

  def current_language
    params[:language] || session[:language] || current_user.try(:default_language) || 'English'
  end

  helper_method :current_language

  private

  def set_language
    session[:language] = params[:language] if params[:language].present?
  end

  def detect_browser
    request.variant = case request.user_agent
                      when /iPad/i
                        :tablet
                      when /iPhone/i
                        :phone
                      when /Android/i && /mobile/i
                        :phone
                      when /Android/i
                        :tablet
                      when /Windows Phone/i
                        :phone
                      else
                        :desktop
                      end
  end
end
