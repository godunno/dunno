Rails.application.routes.draw do

  root controller: 'static', action: '/'
  devise_for :users, skip: :sessions, controllers: { registrations: 'dashboard/users' }
  mount_roboto
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

  get 'dashboard/teacher' => 'dashboard/application#teacher'
  get 'dashboard/student' => 'dashboard/application#student'

  namespace :api do
    namespace :v1 do
      resource :config, only: :show
      namespace :teacher do
        resources :notifications, only: [:create]
        resources :courses, only: [:index, :create, :update, :destroy, :show] do
          member do
            get :students
          end
        end
        resources :events, only: [:index, :create, :update, :destroy, :show]
        resources :polls, only: [] do
          member do
            patch :release
          end
        end
        resources :medias, only: [:index, :create, :update, :destroy] do
          get 'preview', on: :collection
          member do
            patch :release
          end
        end
        resources :topics, only: [:create, :update, :destroy] do
          member do
            patch :transfer
          end
        end
        resources :personal_notes, only: [] do
          member do
            patch :transfer
          end
        end
      end
      resources :ratings, only: :create
      resources :answers, only: :create
      resource :timeline, only: [] do
        resources :messages, only: [:create] do
          member do
            post :up
            post :down
          end
        end
      end
      resources :events, only: [:index, :show]
      resources :courses, only: [:index, :show] do
        member do
          post :register
          delete :unregister
        end
      end
      resources :organizations, only: [:index] do
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
