Rails.application.routes.draw do
  get 'password_resets/new'

  get 'password_resets/edit'

  get  '/signup',  to: 'users#new'
  post '/signup',  to: 'users#create'
  resources :password_resets,     only: [:new, :create, :edit, :update]
  #resources :users
  resources :users do
    member do
      get :following, :followers
    end
  end
  resources :account_activations, only: [:edit]
  resources :microposts,          only: [:create, :destroy]
  resources :relationships,       only: [:create, :destroy]
  root 'static_pages#home'
  get  '/help',    to: 'static_pages#help'
  get  '/about',   to: 'static_pages#about'
  get  '/contact', to: 'static_pages#contact'
  get  '/link', to: 'static_pages#link'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
end
