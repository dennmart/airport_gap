Rails.application.routes.draw do
  root "home#index"

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
