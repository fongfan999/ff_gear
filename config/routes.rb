Rails.application.routes.draw do
  
  root "products#index"
  resources :products, except: [:index] do
    resources :attachments, only: [:create] do
      get :upload, on: :collection
    end
  end

  resources :attachments, only: [:create]
end
