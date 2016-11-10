Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: "omniauth_callbacks" }
  
  mount Commontator::Engine => '/commontator'

  root "welcome#index"

  get :notifications, to: "users#notifications"

  get 'market', to: "market#index"

  resources :posts, except: [:index] do
    patch :favorite, on: :member
  end

  post :attachments, to: "attachments#create"
  patch :attachments, to: "attachments#create"

  resources :notifications do
    collection do
      patch :mark_all_as_read
    end
    
    member do
      patch :mark_toggle_status
    end
  end

  resources :categories, only: [:show]

  resources :users, only: [:show, :update] do
    member do
      get :edit_avatar
      get :edit_name
      get :favorite_posts
    end
  end
end
