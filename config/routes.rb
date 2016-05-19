Myflix::Application.routes.draw do
  root to: "videos#index"

  get "genre(/:id)", to: "categories#show", as: :categories

  # root to: 'videos/index'
  resources :videos, only: [:index, :show]

  get "ui(/:action)", controller: "ui"
end
