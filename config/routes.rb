Rails.application.routes.draw do
  post 'refresh/create'
  post 'signin/create'
  post 'signup/create'

  resources :todos
end
