Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: "omniauth_callbacks" }
  root "welcome#index"

  get 'market', to: "market#index"

  resources :posts, except: [:index]
  post :attachments, to: "attachments#create"
  patch :attachments, to: "attachments#create"

  resources :categories, only: [:show]
  resources :users, only: [:show] do
    patch :change_avatar, on: :member
  end
end
