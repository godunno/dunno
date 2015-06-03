Rails.application.routes.draw do

  root controller: 'static', action: '/'
  devise_for :users, skip: :sessions, controllers: { registrations: 'dashboard/users' }
  mount_roboto

  # TODO: Simplify these routes
  as :user do
    post 'api/v1/users/sign_in' => 'api/v1/sessions#create'
    post 'api/v1/users' => 'dashboard/users#create'
    delete 'api/v1/users/sign_out' => 'api/v1/sessions#destroy'
    get 'api/v1/users/profile' => 'api/v1/sessions#profile'
    patch 'api/v1/users' => 'api/v1/users#update'
    patch 'api/v1/users/password' => 'api/v1/users#update_password'

    # TODO: test redirect when user is not authenticated
    get 'sign_in' => 'dashboard/application#sign_in', as: :new_user_session
    get 'sign_up' => 'dashboard/application#sign_up', as: :new_registration
    post 'users/sign_in' => 'devise/sessions#create', as: :user_session
    delete 'users/sign_out' => 'devise/sessions#destroy', as: :destroy_user_session

    namespace :dashboard do
      resources :passwords, only: [:new, :create, :edit, :update]
      resources :users, only: [] do
        get :accept_invitation, on: :collection
      end
    end
  end

  get 'dashboard' => 'dashboard/application#index'

  namespace :api do
    namespace :v1 do
      resource :config, only: :show
      resources :notifications, only: [:create]
      resources :medias, only: [:index, :create, :update, :destroy] do
        # TODO: Remove this route
        get 'preview', on: :collection
      end
      resources :topics, only: [:create, :update, :destroy] do
        member do
          patch :transfer
        end
      end
      resources :events, only: [:index, :show, :create, :update]
      resources :courses, only: [:index, :show, :create, :update, :destroy] do
        member do
          post :register
          delete :unregister
          # TODO: Check if this route is used
          get :students
        end
      end
      namespace :utils do
        get 's3/credentials' => 's3#credentials'
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
