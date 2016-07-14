class SocialSessionsController < ApplicationController
  def create
    user = User.from_omniauth(env["omniauth.auth"])
    user.confirm!
    sign_in user
    set_flash
    after_sign_in_path_for(user)
  end

private
  def set_flash
    flash[:notice] = nil
    if current_user.start_trial_date.nil?
      session[:show_trial] = true 
    elsif current_user.subscriptions.size == 0
      if current_user.trial_expired?
        flash[:alert] = "Your 7 Days Free Trial has been expired. Please subscribe to continue."
      else
        flash[:notice] = 'You are currently on "7 Days Free Trial". You have full access to all media for 7 Days.'
      end
    end
  end

  def after_sign_in_path_for(resource)
    if session['sso_creds'].present?
      client = Client.find_by_app_id(session['sso_creds']['client_id'])

      AccessGrant.prune!
      create_hash = {
        client: client,
        state: session['sso_creds']['state']
      }

      access_grant = current_user.access_grants.where(create_hash).first_or_create

      return redirect_to access_grant.redirect_uri_for(session['sso_creds']['redirect_uri'])
    else
      return redirect_to categories_path
    end
  end
end
