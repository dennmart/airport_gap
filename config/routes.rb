Rails.application.routes.draw do
  root "home#index"

  get "/login", to: "sessions#new", as: :login
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy", as: :logout

  resources :airports, only: [:index, :show] do
    collection do
      post :distance
    end
  end

  resources :favorites, only: [:index, :show, :create, :update, :destroy]
  resource :tokens, only: [:new, :create, :show] do
    member do
      post :regenerate
    end
  end
end
