Pisma::Application.routes.draw do
  resources :bitcoins do
    get 'double', on: :new
    get 'savefile', on: :member
    get 'corect', on: :member
  end
  resources :reviews
resources :bands do
  get 'double', on: :new
  get 'savefile', on: :member
#  get 'china', on: :member
  get 'corect', on: :member
end
resources :overlooks do
  get 'btcnew', on: :new
  get 'editall', on: :new
  get 'btcedit', on: :member
  get 'btcshow', on: :member
  get 'append', on: :member
end
#170814  match '/show',    to: 'bands#show',    via: 'get' 
  # get "bands/index"
#170814	match '/bands',    to: 'bands#index',    via: 'get'
  # get "bands/create"
#170814	match '/create',    to: 'bands#create',    via: 'get'	#'post'
#170814  get "bands/destroy"
  # get "static_pages/news"
  # match '/news',    to: 'static_pages#news',    via: 'get'
	root 'static_pages#news'
  # get "static_pages/anonce"
  match '/anonce',    to: 'static_pages#anonce',    via: 'get'
  # get "static_pages/article"
  match '/article',    to: 'static_pages#article',    via: 'get'
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
