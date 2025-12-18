require 'rack/router'

ROUTES = Rack::Router.new do
  get '/products' => ProductsController.new.method(:index)
  post '/products' => ProductsController.new.method(:create)
  post '/sessions' => SessionsController.new.method(:create)
  delete '/sessions' => SessionsController.new.method(:delete)
  post '/users' => UsersController.new.method(:create)
  get '/jobs/:id' => JobsController.new.method(:show)
  get '/docs' => Scalar::UI
end
