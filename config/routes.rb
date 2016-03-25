Rails.application.routes.draw do

  get 'sessions/new'

    root                'static_pages#home'
    get  'contact'   => 'static_pages#contact'
    get  'signup'    => 'users#new'
    get    'login'   => 'sessions#new'
    post   'login'   => 'sessions#create'
    delete 'logout'  => 'sessions#destroy'
    get '/invoices' => 'home#invoices'

    match 'search' => 'home#search', :as => :search, :via => :get
    match '/search_model_extended' => 'home#search_model_extended', :as => :search_model_extended, :via => :post
    match 'parts' => 'home#all_parts', :as => :parts, :via => :get
    match '/options_brand' => 'home#options_brand', :as => :options_brand, :via => :post
    match '/options_model' => 'home#options_model', :as => :options_model, :via => :post
    match '/options_model_extended' => 'home#options_model_extended', :as => :options_model_extended, :via => :post

    match '/connect_brand' => 'parts_products#connect_brand', :as => :connect_brand, :via => :post
    match '/connect_model' => 'parts_products#connect_model', :as => :connect_model, :via => :post
    match '/connect_model_extended' => 'parts_products#connect_model_extended', :as => :connect_model_extended, :via => :post

    match '/purchase' => 'carts#purchase', :as => :purchase, :via => :post

    resources :carts
    
    resources :users do
      resources :invoices
    end

    resources :devices do
      resources :products do
        resources :categories do
          resources :parts do
            resources :parts_products
            resources :partdescriptions
            resources :partimages
          end
        end
      end
    end

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
