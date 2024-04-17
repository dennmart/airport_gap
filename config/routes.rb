Rails.application.routes.draw do
  get 'up' => 'rails/health#show', as: :rails_health_check

  root 'home#index'

  get '/docs', to: 'docs#index', as: :docs

  get '/login', to: 'sessions#new', as: :login
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy', as: :logout

  resource :tokens, only: [:new, :create, :show] do
    member do
      post :regenerate
    end
  end

  resource :password_reset, only: [:new, :create, :edit, :update]

  resource :change_password, only: [:show, :update]

  resources :airports, only: [:index]

  namespace :api do
    resources :airports, only: [:index, :show] do
      collection do
        post :distance
      end
    end

    resources :favorites, only: [:index, :show, :create, :update, :destroy] do
      collection do
        delete :clear_all
      end
    end

    resource :tokens, only: [:create]
  end
end
