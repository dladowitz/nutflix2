Myflix::Application.routes.draw do
  get 'videos/index'

  get 'ui(/:action)', controller: 'ui'
end
