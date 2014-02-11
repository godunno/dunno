Dunno::Application.routes.draw do

  devise_for :students
  namespace :api do
    namespace :v1 do
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
