Rails.application.routes.draw do
  # Provider stuff
  match '/auth/sso/authorize' => 'auth#authorize', via: :all
  match '/auth/sso/access_token' => 'auth#access_token', via: :all
  match '/auth/sso/user' => 'auth#user', via: :all
  match '/oauth/token' => 'auth#access_token', via: :all

  # omniauth
  get 'auth/:provider/callback', to: 'social_sessions#create'
  get 'mechat/index'

  namespace :admin do
    resources :media
    resources :games
    resources :categories
    resources :products
    resources :pricing_plans
    resources :users
    resources :subscriptions
    resources :genres
    root to: "media#index"
  end

  namespace :api do
    scope :v1 do
      resource :session, only: [:create, :destroy]
      resource :user, only: [:show]
      resources :categories, only: [:index, :show] do
        member do
          resources :media, only: [:index, :show], controller: 'category_media'
        end
      end
      resources :media, only: [:index, :show]
    end
  end

  devise_for :users, controllers: { sessions: 'users/sessions',
                                    registrations: 'users/registrations'
                                  }

  devise_scope :user do
    get 'profile' => 'users/registrations#profile'

    get 'users/change_password' => 'users/registrations#change_password'

    put 'users/change_password' => 'users/registrations#change_password'

    post 'users/update_avatar' => 'users/registrations#update_avatar'

    post 'users/start_free_trial' => 'users/registrations#start_free_trial'
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'pages#index'
  get 'purchases', to: 'dashboard#purchases', as: 'purchases'
  get 'index', to: 'pages#index', as: 'index' # landing page
  get 'events', to: 'pages#events', as: 'events'

  post 'schedule', to: 'schedules#index'
  # get 'schedule', to: 'schedules#index'
  post 'schedule/:show', to: 'schedules#show'
  get 'schedule/video_feed', to: 'schedules#video_feed'

  resources :products
  resources :categories, only: [:index, :show] do
    resources :media, only: [:index]
  end
  get 'media/:number', to: 'media#show', as: 'media'
  resource :checkout, only: :create
  resources :orders, only: [:new, :create]
  resources :favorite_media, only: [:create, :destroy]
  resources :subscriptions
  resources :ebooks

  get 'music', to: 'categories#music'
  post 'music', to: 'categories#music'
  get 'music/more_musics', to: 'categories#more_musics'

  get 'search', to: 'search#index', as: 'search'
  get 'user_info', to: 'user_info#show'
  
  match '*path', to: 'auth#cors_options', via: :options

  get '*unmatched', to: 'application#not_found'
  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
