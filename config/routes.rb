Rails.application.routes.draw do
  root 'home#home'

  get 'terms' => 'home#terms'
  get 'policy' => 'home#policy'

  devise_for :users,
             skip: :sessions,
             controllers: {
               registrations: 'dashboard/users',
               omniauth_callbacks: "dashboard/omniauth_callbacks"
             }
  mount_roboto

  as :user do
    post 'api/v1/users/sign_in' => 'api/v1/sessions#create'
    post 'api/v1/users' => 'dashboard/users#create'
    delete 'api/v1/users/sign_out' => 'api/v1/sessions#destroy'
    get 'api/v1/users/profile' => 'api/v1/sessions#profile'
    patch 'api/v1/users' => 'api/v1/users#update'
    patch 'api/v1/users/password' => 'api/v1/users#update_password'

    get 'sign_in' => 'dashboard/application#sign_in', as: :new_user_session
    get 'sign_up' => 'dashboard/application#sign_up', as: :new_registration
    post 'users/sign_in' => 'devise/sessions#create', as: :user_session
    delete 'users/sign_out' => 'devise/sessions#destroy', as: :destroy_user_session

    namespace :dashboard do
      resource :password, only: [:new, :create, :edit, :update]
    end
  end

  get 'dashboard' => 'dashboard/application#index'

  namespace :api do
    namespace :v1 do
      resource :config, only: :show
      resources :notifications, only: [:create]
      resources :medias, only: [:index, :create, :update, :destroy, :show] do
        get 'preview', on: :collection
      end
      resources :topics, only: [:create, :update, :destroy] do
        member do
          patch :transfer
        end
      end
      resources :comments, only: [:create, :destroy] do
        member do
          patch :block
          patch :unblock
          patch :restore
        end
      end
      resources :events, param: :start_at, only: [:index, :show, :create, :update]
      resources :courses, only: [:index, :show, :create, :update, :destroy] do
        member do
          post :register
          delete :unregister
          get :search
          patch :block
          patch :unblock
          patch :promote_to_moderator
          patch :downgrade_from_moderator
          get :analytics
          post :clone
        end
      end
      resources :weekly_schedules, only: [:create, :destroy] do
        member do
          patch :transfer
          get :affected_events_on_transfer
        end
      end
      resources :attachments, only: [:create, :destroy]
      resources :system_notifications, only: [:index, :show] do
        collection do
          get :new_notifications
          patch :viewed
          post :mark_all_as_read
        end
      end
    end
    namespace :v2 do
      resources :courses, only: [:index] do
        resources :events, only: :index
      end
      resources :keys, only: [:create]
    end
  end
end
