Rails.application.routes.draw do
    root                'static_pages#home'
    get  'contact'   => 'static_pages#contact'
    get  'signup'    => 'users#new'
    get    'login'   => 'sessions#new'
    post   'login'   => 'sessions#create'
    delete 'logout'  => 'sessions#destroy'
    get '/invoices' => 'home#invoices'

    get 'search' => 'home#search', :as => :search
    get '/search_model_extended' => 'home#search_model_extended', :as => :search_model_extended
    get 'parts' => 'home#all_parts', :as => :parts
    get 'part' => 'home#part', :as => :part
    get 'suited' => 'home#suitable_products', :as => :suited
    get '/options_brand' => 'home#options_brand', :as => :options_brand
    get '/options_model' => 'home#options_model', :as => :options_model
    get '/options_model_extended' => 'home#options_model_extended', :as => :options_model_extended
    get '/options_device' => 'home#options_device', :as => :options_device

    get '/connect_brand' => 'parts_products#connect_brand', :as => :connect_brand
    get '/connect_model' => 'parts_products#connect_model', :as => :connect_model
    get '/connect_model_extended' => 'parts_products#connect_model_extended', :as => :connect_model_extended
    get 'send_tell_a_friend' => 'parts#send_tell_a_friend', :as => :send_tell_a_friend

    get '/purchase' => 'carts#purchase', :as => :purchase

    get '/coupon_category' => 'coupons#coupon_category', :as => :coupon_category
    get '/coupon_part' => 'coupons#coupon_part', :as => :coupon_part

    resources :coupons

    resources :users do
      resources :reminders
      resources :invoices
      resources :carts do
        resources :cart_items
      end
    end
    resources :password_resets,     only: [:new, :create, :edit, :update]
    resources :account_activations, only: [:edit]

    resources :locations

    resources :devices do
      resources :products do
        resources :categories do
          resources :parts do
            resources :parts_products
            resources :partimages
            resources :discount_prices
            resources :part_stocks
            resources :partdescriptions do
              resources :part_subdescriptions
            end
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
