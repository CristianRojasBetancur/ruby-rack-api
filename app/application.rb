class Application
  include ResponseHelper
  include ErrorsHandler

  def call(env)
    response = ROUTES.call(env)
    return not_found_response if response.first.eql?(404)

    response
  end

  private

  def not_found_response
    error_data = build_error('not_found')

    error_response([error_data], 404)
  end
end
