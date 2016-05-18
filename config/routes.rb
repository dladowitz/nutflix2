Myflix::Application.routes.draw do
  # root to: 'videos/index'
  get 'videos/index'

  get 'ui(/:action)', controller: 'ui'
end
