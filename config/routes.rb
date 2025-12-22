Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # This makes http://localhost:3000/bank_slips work
  resources :bank_slips, only: [:index, :create] do
    member do
      patch :pay
      patch :cancel
    end
  end
  # Defines the root path route ("/")
  # root "posts#index"
  # This makes the homepage http://localhost:3000/ show your index
  root "bank_slips#index"

  namespace :api do
    namespace :v1 do
      resources :bank_slips, only: [:index, :create, :show]
    end
  end
end
