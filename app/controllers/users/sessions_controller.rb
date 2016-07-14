class Users::SessionsController < Devise::SessionsController
  skip_before_action :verify_authenticity_token, only: :destroy

  def create
    if params[:user] && params[:user][:promo_code].present?
      user = User::Promo.find_or_create_by_code(params[:user][:promo_code])
      if user.present?
        sign_in(user, bypass: true)
        redirect_to(categories_path) && return
      end
    end
    super
  end

  private

  def after_sign_in_path_for(_resource)
    set_flash

    if session['sso_creds'].present?
      client = Client.find_by_app_id(session['sso_creds']['client_id'])

      AccessGrant.prune!
      create_hash = {
        client: client,
        state: session['sso_creds']['state']
      }

      access_grant = current_user.access_grants.where(create_hash).first_or_create

      access_grant.redirect_uri_for(session['sso_creds']['redirect_uri'])
    else
      categories_path
    end
  end

  def set_flash
    flash[:notice] = nil
    # if resource.start_trial_date.nil?
    if current_user.start_trial_date.nil?
      session[:show_trial] = true 
    elsif current_user.subscriptions.size == 0
      if current_user.trial_expired?
        flash[:alert] = 'Your 7 Days Free Trial has been expired. Please subscribe to continue.'
      else
        flash[:notice] = 'You are currently on "7 Days Free Trial". You have full access to all media for 7 Days.'
      end
    end
  end
end
