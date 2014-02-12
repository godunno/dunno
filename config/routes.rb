Dunno::Application.routes.draw do

  devise_for :teachers
  devise_for :students

  namespace :dashboard do
    resources :organizations, only: [] do
      resources :events
    end
  end

  namespace :api do
    namespace :v1 do
      resource :timeline, only: [] do
        resources :messages, only: [:create]
      end
      resources :organizations, only:[] do
        resources :events, only: [:index] do
          member do
            get :attend
          end
        end
      end
    end
  end
end
