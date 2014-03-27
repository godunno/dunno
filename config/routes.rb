Dunno::Application.routes.draw do

  devise_for :teachers
  devise_for :students, path: 'api/v1/students', controllers: { sessions: 'api/v1/sessions' }, only: :sessions
  devise_for :students, skip: :sessions
  devise_scope :teacher do
    post 'api/v1/teachers/sign_in' => 'api/v1/sessions#create'
  end

  namespace :dashboard do
    resources :topics
    resources :polls, only: [] do
      member do
        patch :release
      end
    end
    resources :courses
    resources :events do
      member do
        patch :open
        patch :close
      end
    end
    resources :organizations, only: [] do
    end
  end

  namespace :api do
    namespace :v1 do
      namespace :teacher do
        resources :events, only: [] do
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
        end
      end
      resources :organizations, only:[:index] do
      end
    end
  end
end
