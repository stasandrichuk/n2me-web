class User < ActiveRecord::Base
  PROMO_CODE_REGEXP = /\ASCI([0-2]\d\d|300)$/i

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :confirmable

  acts_as_token_authenticatable

  has_many :authentications
  has_many :subscriptions
  has_many :access_grants, dependent: :delete_all


  has_and_belongs_to_many :stations, :join_table => "users_stations"
  has_and_belongs_to_many :genres, :join_table => "users_genres"

  has_one :preference

  validates :name, :email, presence: true
  validates_uniqueness_of :email
  validate :confirmation_matches_password


  AVATAR = { :default => 0, :gravatar => 1, :uploaded => 2 }

  mount_uploader :avatar, AvatarUploader

  Roles = {
    'ADMIN' => :admin,
    'USER' => :user
  }.freeze

  # Dynamically generate methods for each role e.g is_admin?
  # as there can be more roles in future
  Roles.each do |constant, name|
    define_method("is_#{name}?") { role == constant.downcase }
  end

  attr_accessor :promo_code

  def gravatar
    gravatar_id = Digest::MD5.hexdigest(email).downcase
    "https://www.gravatar.com/avatar/#{gravatar_id}.jpg?d=identicon&s=150"
  end

  def avatar_url
    if avatar_option == AVATAR[:default]
      '/img/avatars/user.png'
    elsif avatar_option == AVATAR[:gravatar]
      gravatar
    else
      avatar.thumb.url
    end
  end

  def display_name
    name.present? ? name : email
  end

  def short_name
    name.present? ? name.split(' ')[0] : email.split('@')[0]
  end

  def push_media_to_history(media_id)
    recently_viewed_media_ids.unshift(media_id)
    self.recently_viewed_media_ids = recently_viewed_media_ids.uniq[0..15]
    update_attributes(recently_viewed_media_ids: recently_viewed_media_ids)
  end

  def recently_viewed_media(num_of_items = 0)
    recently_viewed_media_ids[0..(num_of_items - 1)].map do |number|
      Medium.find_by(number: number)
    end.compact
  end

  def favorite_media
    FavoriteMedium.where(user_id: id).map do |fm|
      Medium.find_by(number: fm.media_number)
    end
  end

  def generate_api_authentication_token
    token = Devise.friendly_token
    while User.find_by(authentication_token: token)
      token = Devise.friendly_token
    end
    update_columns(authentication_token: token)
  end

  def subscribed_products
    products = []
    subscriptions.each do |sub|
      products = products.concat([sub.product]) if sub.product
    end
    products.uniq
  end

  def subscribed_media
    media = []
    subscriptions.each do |sub|
      media = media.concat(sub.media)
    end
    media.uniq
  end

  def trial_expired?
    if start_trial_date.present?
      days = (Time.now.to_date - start_trial_date.to_date).to_i
      return days > 7 ? true : false
    end
    true
  end

  def can_view_media?(media)
    return true unless trial_expired?

    basic_plan_media = Media.basic_plan_media.where(:id => media.id).first

    return true if basic_plan_media.present?
    category_ids = media.categories.map(&:id)
    subscriptions.each do |sub|
      target = sub.product.present? ? sub.product : sub
      if !target.media.where(id: media.id).empty?
        return true
      elsif !target.categories.where(id: category_ids).empty?
        return true
      end
    end
    false
  end

  def subscribe_to_products
    subscribed_product_ids = subscriptions.map(&:product_id).compact
    Product.where.not(id: subscribed_product_ids)
  end

  def subscribe_to_channels
    subscribed_media_ids = []
    subscriptions.map { |x| subscribed_media_ids = subscribed_media_ids.concat(x.media.map(&:id)) }
    @additional_products = Medium.where.not(pricing_plan: nil, id: subscribed_media_ids)
  end

  def genre_ids=(genre_ids)
    if genre_ids.is_a?(String)
      genre_ids = genre_ids.split(',')
    end
    super
  end

  def self.from_omniauth(auth)
    user_email = User.find_by_email auth.info.email
    user_email = "#{auth.uid}@#{auth.provider}.com" if user_email.to_s.blank?

    user_name = auth.info.try('name').to_s.blank? ? '--' : auth.info.try('name').to_s

    @usr = User.find_by_email user_email

    unless @usr
      password = SecureRandom.hex
      @usr = User.create!(
        email: user_email,
        password: password,
        password_confirmation: password,
        name: user_name
      )
      
      if auth.info.image.present?
        @usr.remote_avatar_url = process_uri(auth.info.image) 
        @usr.avatar_option = 2
      else
        @usr.avatar_option = 1
      end

      @usr.save!

    end
    authentication = @usr.authentications.where(provider: auth.provider).first

    unless authentication
      authentication = Authentication.create!(
        user_id: @usr.id,
        provider: auth.provider,
        uid: auth.uid,
        oauth_token: auth.credentials.token,
        oauth_expires_at: 2.days.from_now.to_datetime
      )
    end
    @usr
  end

  class Promo
    def self.find_or_create_by_code(code)
      return false unless code.match(User::PROMO_CODE_REGEXP)
      user = User.find_or_create_by(email: "#{code}@n2me.tv".downcase)
      user.password = code * 2
      user.save(validate: false) && user
    end
  end

  private

  def confirmation_matches_password
    unless password == password_confirmation
      errors.add(:base, "Password confirmation doesn't match password")
    end
  end

  def self.process_uri(uri)
    require 'open-uri'
    require 'open_uri_redirections'
    open(uri, allow_redirections: :safe) do |r|
      r.base_uri.to_s
    end
  end
end
