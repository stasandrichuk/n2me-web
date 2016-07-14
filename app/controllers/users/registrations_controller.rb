class Users::RegistrationsController < Devise::RegistrationsController
  layout proc { |_controller| user_signed_in? ? 'new_layout' : 'devise' }

  skip_before_filter :verify_authenticity_token, :only => [:update_avatar]
  before_action :get_genres, :only => [:edit, :update]
  respond_to :json

  def profile
    redirect_to(new_user_session_path) && return if current_user.blank?
    @subscriptions = current_user.subscriptions

    render 'users/registrations/profile'
  end

  def after_sign_up_path_for(_resource)
    all_stations = Station.all.order('s_id ASC, id ASC')
    current_user.stations << all_stations

    preference_settings = Preference.new(initial_time: 'now', station_filter: 'broadcast,cable,community', time_span: 3, grid_height: 7)
    current_user.preference = preference_settings

    products_path
  end

  def change_password
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    if request.put?
      if self.resource.valid_password?(params[:user][:current_password])
        self.resource.update_with_password(account_update_params)
        if resource.errors.size == 0
          sign_in(resource, :bypass => true)
          redirect_to profile_path; return;
        end
      else
        flash.now[:alert] = "Invalid current password."
      end
    end
  end

  def update_avatar
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    resource_updated = update_resource(resource, account_update_params)
    render layout: false
  end

  def start_free_trial
    # TODO: store stripeToken
    current_user.update_attributes(start_trial_date: Time.now)
    redirect_to categories_path, notice: 'You are currently on "7 Days Free Trial"'
  end

  def after_update_path_for(resource)
    profile_path
  end

  private

  def get_genres
    @genres = Genre.order("title ASC").map{|x| x.attributes.reject{|y| ['created_at', 'updated_at'].include?(y)}}
  end

  def sign_up_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def account_update_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :avatar_option, :avatar, :genre_ids, :current_password)
  end

  def update_resource(resource, params)
    resource.update_without_password(params)
  end
end
