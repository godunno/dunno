Dunno::Application.routes.draw do

  devise_for :teachers
  devise_for :students, path: 'api/v1/students', controllers: { sessions: 'api/v1/sessions' }

  namespace :dashboard do
    resources :topics
    resources :organizations, only: [] do
      resources :events do
        member do
          patch :open
          patch :close
        end
      end
    end
  end

  namespace :api do
    namespace :v1 do
      resources :ratings, only: :create
      resource :timeline, only: [] do
        resources :messages, only: [:create] do
          member do
            post :up
            post :down
          end
        end
      end
      resources :organizations, only:[:index] do
        resources :events, only: [:index] do
          member do
            get :attend
            get :timeline
          end
        end
      end
    end
  end
end
