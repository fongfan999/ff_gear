Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: "omniauth_callbacks" }
  root "products#index"

  resources :products, except: [:index]
  post :attachments, to: "attachments#create"
  patch :attachments, to: "attachments#create"
  resources :users
end
