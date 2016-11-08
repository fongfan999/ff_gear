Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: "omniauth_callbacks" }
  
  mount Commontator::Engine => '/commontator'

  root "welcome#index"

  get 'market', to: "market#index"

  resources :posts, except: [:index] do
    patch :favorite, on: :member
    member do
      post :push_notification
    end
  end

  post :attachments, to: "attachments#create"
  patch :attachments, to: "attachments#create"

  resources :categories, only: [:show]

  resources :users, only: [:show, :update] do
    member do
      get :edit_avatar
      get :edit_name
      get :favorite_posts
    end
  end
end
