Myflix::Application.routes.draw do
  root to: "static_pages#front"

  # Invdidual Routes
  get "genre(/:id)", to: "categories#show", as: :categories
  get "register",    to: "users#new", as: :register
  #
  get "ui(/:action)", controller: "ui"

  # Resource Routes
  resources :users, only: [:new, :create]
  resources :sessions, only: [:new, :create]

  resources :videos, only: [:index, :show] do
    collection do
      get "search"
    end
  end

end
