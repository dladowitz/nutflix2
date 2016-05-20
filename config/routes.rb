Myflix::Application.routes.draw do
  root to: "static_pages#front"

  # Invdidual Routes
  get "genre(/:id)",  to: "categories#show", as: :categories

  #
  get "ui(/:action)", controller: "ui"

  # Resource Routes
  resources :users, only: [:new ]

  resources :videos, only: [:index, :show] do
    collection do
      get "search"
    end
  end

end
