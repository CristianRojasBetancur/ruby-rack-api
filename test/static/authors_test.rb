require_relative '../test_helper'

class AuthorsTest < Minitest::Test
  include Rack::Test::Methods
  include TestApp
  include Support::RequestsSupport

  def test_authors_cached
    api_credentials
    get '/AUTHORS'

    assert_equal 200, last_response.status, 'Status should be 200'
    assert_equal "public, max-age=#{24 * 3600}", last_response.headers['Cache-Control'], 'Response could be cached for 24 hours'
  end
end
