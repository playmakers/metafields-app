PlaymakersApp::Application.routes.draw do
  get 'welcome' => 'home#welcome'
  get 'design'  => 'home#design'

  controller :sessions do
    get    'login'                 => :new
    post   'login'                 => :create
    get    'auth/shopify/callback' => :show
    delete 'logout'                => :destroy
  end

  get  'products/:id/variants/:variant_id/image.:format' => 'images#variant'

  get  'images'               => 'images#show'
  get  'products'             => 'products#show'
  get  'products/metafields'  => 'products#metafields'
  post 'products/metafields'  => 'products#metafields'

  root :to => 'home#index'
end
