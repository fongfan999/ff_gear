Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: "omniauth_callbacks" }
  root "welcome#index"

  get 'market', to: "market#index"

  resources :categories, only: [:show]


  resources :products, except: [:index]
  post :attachments, to: "attachments#create"
  patch :attachments, to: "attachments#create"
  resources :users
end
