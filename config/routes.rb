Rails.application.routes.draw do
  get 'home/index'
  root "home#index"

  resources :airports, only: [:index, :show] do
    collection do
      post :distance
    end
  end

  resources :favorites, only: [:index, :show, :create, :update, :destroy]
end
