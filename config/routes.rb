PlaymakersApp::Application.routes.draw do
  controller :sessions do
    get    'login'                 => :new
    post   'login'                 => :new
    get    'auth/shopify/callback' => :show
    # post   'login'                 => :create
    # delete 'logout'                => :destroy
  end

  get  'products/:id/variants/:variant_id/image.:format' => 'images#variant'


  # get 'welcome' => 'home#welcome'
  # get 'design'  => 'home#design'

  # get  'images'               => 'images#show'
  # get  'products'             => 'products#show'
  # get  'products/metafields'  => 'products#metafields'
  # post 'products/metafields'  => 'products#metafields'

  root :to => 'home#index'
end
