require_relative '../test_helper'

class AuthorsTest < Minitest::Test
  include Rack::Test::Methods
  include TestApp

  def test_authors_cached
    get '/authors'

    assert_equal 200, last_response.status
    assert_equal "max-age=#{24 * 3600}", last_response.headers['Cache-Control']
  end
end
