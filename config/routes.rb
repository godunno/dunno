Dunno::Application.routes.draw do

  devise_for :teachers
  devise_for :students

  namespace :dashboard do
    resources :organizations, only: [] do
      resources :events do
        member do
          patch :open
        end
      end
    end
  end

  namespace :api do
    namespace :v1 do
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
