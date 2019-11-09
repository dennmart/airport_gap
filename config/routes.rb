Rails.application.routes.draw do
  resources :airports, only: [:index, :show]
end
