Rails.application.routes.draw do
  
  devise_for :users, controllers: { omniauth_callbacks: "omniauth_callbacks" }
  root "products#index"
  resources :products, except: [:index] do
    resources :attachments, only: [:create] do
      get :upload, on: :collection
    end
  end

  resources :attachments, only: [:create]
  patch :attachments, to: "attachments#update"
end
