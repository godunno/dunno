Dunno::Application.routes.draw do

  devise_for :users, skip: :sessions, controllers: { registrations: 'dashboard/registrations' }
  mount_roboto
  apipie
  as :user do
    post 'api/v1/users/sign_in' => 'api/v1/sessions#create'
    delete 'api/v1/users/sign_out' => 'api/v1/sessions#destroy'

    # TODO: test redirect when user is not authenticated
    get 'sign_in' => 'dashboard/application#sign_in', as: :new_user_session
    post 'users/sign_in' => 'devise/sessions#create', as: :user_session
    delete 'users/sign_out' => 'devise/sessions#destroy', as: :destroy_user_session
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
        resources :events, only: [:index, :create, :update, :destroy, :show] do
          member do
            patch :open
            patch :close
          end
        end
        resources :polls, only: [] do
          member do
            patch :release
          end
        end
        resources :medias, only: [:create] do
          member do
            patch :release
          end
        end
        resources :topics, only: [] do
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
      resources :events, only: [:index] do
        member do
          get :attend
          get :timeline
          patch :validate_attendance
        end
      end
      resources :courses, only: [:index, :show] do
        member do
          post :register
          delete :unregister
        end
      end
      resources :organizations, only: [:index] do
      end
    end
  end
end
