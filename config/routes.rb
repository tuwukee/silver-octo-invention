Rails.application.routes.draw do
  post 'refresh/create'
  post 'signin/create'
  post 'signup/create'
  delete 'signin/destroy'

  resources :todos
end
