Rails.application.routes.draw do
  

  devise_for :users, controllers: { omniauth_callbacks: "omniauth_callbacks" }
  
  mount Commontator::Engine => '/commontator'

  root "market#index"
  
  get "/about" => "main#about"
  get "/search" => "main#search"

  resources :main do
    
  end

  # Admin namespace
  namespace :admin do
    root 'application#index', as: :root
  end

  get '/notifications', to: "users#notifications"
  get '/favorite_posts', to: "users#favorite_posts"

  resources :posts, except: [:index] do
    member do
      patch :favorite
      patch :mark_as_sold
      patch :report
    end

    collection do
      get :autocomplete_post_name
    end
  end

  post :attachments, to: "attachments#create"
  patch :attachments, to: "attachments#create"

  resources :notifications, only: [:destroy] do
    collection do
      patch :mark_all_as_read
    end
    
    member do
      patch :mark_toggle_status
    end
  end

  resources :categories, only: [:show]

  get '/:username', to: "users#profile", as: :user_profile

  get '/:username/posts', to: "posts#index", as: :user_posts

  resources :users, only: [:show, :edit, :update] do
    member do
      get :edit_avatar
    end
  end

  resources :profiles, only: :update
end
