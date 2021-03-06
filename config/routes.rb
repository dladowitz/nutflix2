Myflix::Application.routes.draw do
  root to: "static_pages#front"

  # Invdidual Routes
  get "genre(/:id)", to: "categories#show",  as: :categories
  get "home",        to: "videos#index",     as: :home
  get "register",    to: "users#new",        as: :register
  get "sign_in",     to: "sessions#new",     as: :sign_in
  delete "sign_out", to: "sessions#destroy", as: :sign_out

  #
  get "ui(/:action)", controller: "ui"

  # Resource Routes
  resources :reviews, only: [:create]
  resources :sessions, only: [:new, :create, :destroy]

  resources :videos, only: [:index, :show] do
    collection do
      get "search"
    end
  end

  # Nested Resources
  resources :users, only: [:new, :create, :show] do
    resources :queue_items, only: [:index, :create, :destroy] do
      collection do
        post "reorder"
      end
    end
  end
end
