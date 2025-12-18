class Authentication
  include ErrorsHandler
  include ResponseHelper

  PUBLIC_PATHS = [
    { path: '/sessions', methods: ['POST'] },
    { path: '/docs', methods: ['GET'] },
    { path: '/users', methods: ['POST'] }
  ].freeze

  def initialize(app)
    @app = app
  end

  def call(env)
    req = Rack::Request.new(env)
    return @app.call(env) if public_path?(req.path_info, req.request_method)

    error_data = build_error('unauthorized')
    return error_response([error_data], 401) unless req.session[:user_id]

    @app.call(env)
  end

  private

  def public_path?(path, method)
    PUBLIC_PATHS.any? { |route| route[:path] == path && route[:methods].include?(method) }
  end
end
