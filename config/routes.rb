Rails.application.routes.draw do
  devise_for :users
  # resources :tasks
  root to: "projects#index"

  resources :tasks do
    member do
      patch :up
      patch :down
    end
  end

  resources :projects
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
