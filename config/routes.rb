Rails.application.routes.draw do

  get 'home/index'
  post 'home_message', to: 'home#create_home_message'

  get 'dashboard' => 'account#dashboard'

  devise_for :users
  devise_for :admins, only: :sessions
  devise_for :sellers, only: :sessions
  resources :sellers, only: [:edit, :update]

  get 'platforms', to: 'account#index_platforms'
  
  resources :magentos, except: [:index, :show]


  authenticated :seller do
    root 'account#dashboard', as: :authenticated_seller_root
  end

  authenticated :admin do
    root 'rails_admin/main#dashboard', as: :authenticated_admin_root
  end

  root 'home#index'

  mount RailsAdmin::Engine => '/backhere/admin', as: 'rails_admin'

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
