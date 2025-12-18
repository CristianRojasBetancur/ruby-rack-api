require_relative '../test_helper'

class OpenapiTest < Minitest::Test
  include Rack::Test::Methods
  include TestApp

  def test_openapi_is_not_cached
    get '/openapi.yml'

    assert_equal 200, last_response.status
    assert_equal 'no-store, no-cache, must-revalidate, max-age=0', last_response.headers['Cache-Control']
  end
end
