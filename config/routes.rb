Myflix::Application.routes.draw do
  get 'categories/show'

  # root to: 'videos/index'
  resources :videos, only: [:index, :show]

  get 'ui(/:action)', controller: 'ui'
end
