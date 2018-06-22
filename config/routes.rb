Rails.application.routes.draw do
  post 'refresh', controller: :refresh, action: :create
  post 'signin', controller: :signin, action: :create
  post 'signup', controller: :signup, action: :create
  delete 'signin', controller: :signin, action: :destroy
  get 'me', controller: :users, action: :me

  resources :todos

  namespace :admin do
    resources :users, only: [:index] do
      resources :todos, only: [:index], controller: 'users/todos'
    end
  end
end
