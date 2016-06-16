Rails.application.routes.draw do
  require 'sidekiq/web'
  require 'sidekiq/cron/web'

  devise_for :admins, only: :sessions
  devise_for :users, only: :sessions

  authenticated :user do
    root 'account#dashboard', as: :authenticated_user_root
  end

  authenticated :admin do
    root 'rails_admin/main#dashboard', as: :authenticated_admin_root
    mount Sidekiq::Web => '/sidekiq'
  end

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  
  root 'home#index'
  
  post 'home_message', to: 'home#create_home_message'
  get 'home/index'
  get 'dashboard' => 'account#dashboard'
  get 'platforms', to: 'account#index_platforms'

  resources :users, only: [:edit, :update]

  resources :tasks, only: [:index, :create, :new, :show] do
    collection do
      delete 'delete_delayer/:id', to: 'tasks#delete_delayer', as: 'delete_delayer'
    end
  end

  resources :customers, only: [:index, :show]
  resources :statuses, only: [:index, :update, :create]
  resources :orders, only: [:index, :show]
  resources :surveys, except: [:show] do
    get 'preview'
    post 'answer', to: 'surveys#submit_answer'
  end
  
  resources :magentos, except: [:index, :show] do
    get 'update_specific_version', to: 'magentos#update_specific_version'
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
