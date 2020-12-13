Rails.application.routes.draw do
  resources :tags, except: [:show]
  resources :items, only: [:index, :create, :destroy]
  resource :users, only: [:create]
  post "/login", to: "users#login"
end
