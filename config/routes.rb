Rails.application.routes.draw do
  get 'dashboard/index'
  resources :products

  root to: 'dashboard#index'

  namespace :api do
    resources :products, only: [:index, :create, :update, :destroy] do
   end
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
