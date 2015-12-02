Rails.application.routes.draw do

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users, controllers: { registrations: "registrations", invitations: "users/invitations", omniauth_callbacks: "users/omniauth_callbacks" }
  devise_scope :user do
    get 'users/profile' => 'users#show', as: :show_profile
    get 'users/profile/edit' => 'registrations#edit_profile', as: :edit_profile
    put 'users/profile/update' => 'registrations#update_profile', as: :update_profile
   end
  resources :listings
  resources :transactions, only: [:new, :create]
  resources :messages, only: [:create]
  resources :crews, only: [:create]
  resources :pictures, only: [:destroy]

  resources :signatures, only: [:show, :create] do
    collection do
      post 'callbacks'
    end
  end

  get  'bookingrequests/'  => 'booking_requests#index'
  get  'bookingrequest/'   => 'booking_requests#show'
  post 'bookingrequests/accept' => 'booking_requests#accept'
  post 'bookingrequests/reject' => 'booking_requests#reject'

  post 'listings/orbit'
  post 'listings/unorbit'
  post 'listings/update_date'
  post 'listings/request' => 'listings#booking_request'
  get  'crews/leave' => 'crews#leave_crew'
  patch 'crews/add_user'

  get '/requests/accept' => 'crew_requests#accept_request'
  get '/requests/reject' => 'crew_requests#reject_request'

  get 'search/results'

  get 'dashboard' => 'dashboard#index'
  get 'dashboard/crews' => 'dashboard#crews'
  get 'dashboard/myproperties' => 'dashboard#properties'
  get 'dashboard/following' => 'dashboard#following'
  get 'dashboard/requests' => 'dashboard#requests'

  get 'tos'      => 'pages#tos'
  get 'privacy'  => 'pages#privacy'
  get 'equal'    => 'pages#equal'

  root to: "pages#index"

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
