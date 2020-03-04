Rails.application.routes.draw do
  get 'accounts/show'
  get 'accounts/edit'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  root to: 'tasks#index'

  namespace :admin do
    resources :users
  end

  resources :tasks do
    member do
      get :done
    end
  end

  resource :account, only: [:show, :edit, :update]
end
