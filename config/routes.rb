Rails.application.routes.draw do
  resources :airports, only: [:index, :show] do
    collection do
      post :distance
    end
  end
end
