PlaymakersApp::Application.routes.draw do
  controller :sessions do
    get    'login'                 => :new
    post   'login'                 => :new
    get    'auth/shopify/callback' => :show
    delete 'logout'                => :destroy
  end

  get  'import'   => 'products#update_variant_quantities'

  get 'products/show' => redirect { |params, req|
    "/products/#{req.query_parameters['id']}"
  }

  get  'products/:id' => 'products#show'
  get  'products/edit' => 'products#edit'

  root :to => 'home#index'
end
