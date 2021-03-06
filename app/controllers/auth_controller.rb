class AuthController < ApplicationController
  # This is our new function that comes before Devise's one
  before_filter :authenticate_user_from_token!, :except => [:access_token, :cors_options]

  after_filter :set_cors_headers
  before_filter :authenticate_user!, :except => [:access_token, :cors_options]
  skip_before_filter :verify_authenticity_token

  def authorize
    # Note: this method will be called when the user
    # is logged into the provider
    #
    # So we're essentially granting him access to our
    # system by generating certain tokens and then
    # redirecting him back to the params[:redirect_uri]
    # with a random code and the params[:state]
    AccessGrant.prune!
    create_hash = {
      client: application,
      state: params[:state]
    }
    access_grant = current_user.access_grants.where(create_hash).first_or_create

    redirect_to access_grant.redirect_uri_for(params[:redirect_uri])
  end

  # POST
  def access_token
    application = Client.authenticate(params[:client_id], params[:client_secret])

    if application.nil?
      render :json => {:error => "Could not find application"}
      return
    end

    access_grant = AccessGrant.authenticate(params[:code], application.id)
    if access_grant.nil?
      render :json => {:error => "Could not authenticate access code"}
      return
    end

    # access_grant.start_expiry_period!
    render :json => {:access_token => access_grant.access_token, :refresh_token => access_grant.refresh_token, :expires_in => 2.days, secret: access_grant.code}
  end

  def user    
    hash = {
      provider: 'sso',
      id: current_user.id.to_s,
      info: {
         email: current_user.email,
      },
      extra: {
        #  first_name: current_user.first_name,
        #  last_name: current_user.last_name
        first_name: '',
        last_name: ''
      }
    }

    render :json => hash.to_json
  end

  def cors_options
    render text: 'ok'
  end

  protected

  def application
    @application ||= Client.find_by_app_id(params[:client_id])
  end

  private

  def authenticate_user_from_token!
    session[:sso_creds] = { client_id: params[:client_id], redirect_uri: params[:redirect_uri], response_type: params[:response_type], state: params[:state] }

    if params[:oauth_token]
      access_grant = AccessGrant.where(access_token: params[:oauth_token]).take
      if access_grant.user
        # Devise sign in
        sign_in access_grant.user
      end
    end
  end

  def set_cors_headers
    headers['Access-Control-Allow-Origin'] = "* #{request.env['HTTP_ORIGIN']}"
    headers['Access-Control-Allow-Methods'] = 'POST, GET, PUT, OPTIONS'
    headers['Access-Control-Allow-Headers'] = 'X-Requested-With'
    headers['Access-Control-Max-Age'] = '1728000'
  end
end
