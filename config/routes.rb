Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: "omniauth_callbacks" }
  root "products#index"

  resources :products, except: [:index]
  resources :attachments, only: [:create]
  resources :users
end
