Myflix::Application.routes.draw do
  root to: "videos#index"

  # Invdidual Routes
  get "genre(/:id)",  to: "categories#show", as: :categories

  # 
  get "ui(/:action)", controller: "ui"

  # Resource Routes
  resources :videos, only: [:index, :show]

end
