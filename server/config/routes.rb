Rails.application.routes.draw do
  namespace :turbo do
    namespace :ios do
      resources :configurations, only: [] do
        get :ios_v1, on: :collection
      end
    end
  end
  resources :todos
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "todos#index"
end
