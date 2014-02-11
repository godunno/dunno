Dunno::Application.routes.draw do

  devise_for :students
  namespace :api do
    namespace :v1 do
      resource :timeline, only: [] do
        resources :messages, only: [:create]
      end
      resources :organizations, only:[] do
        resources :events do
          member do
            get :attend
          end
        end
      end
    end
  end
end
