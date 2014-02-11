Dunno::Application.routes.draw do

  devise_for :students
  namespace :api do
    namespace :v1 do
      resources :organizations, only:[] do
        resources :events, only: [:index, :create, :new, :edit] do
          member do
            get :attend
          end
        end
      end
    end
  end

end
