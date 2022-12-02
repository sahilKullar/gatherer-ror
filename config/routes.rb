Rails.application.routes.draw do
  # resources :tasks
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
