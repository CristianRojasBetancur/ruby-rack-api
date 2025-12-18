require_relative '../test_helper'

class ProductsIntegrationTest < Minitest::Test
  include Rack::Test::Methods
  include TestApp
  include Support::RequestsSupport
  include Support::ResponseSupport

  def test_list_products_flow
    email, password = 'user@example.com', 'validPassword123'

    post_user({ email: email, password: password })
    assert_equal 201, last_response.status

    post_session({ email: email, password: password })
    assert_equal 201, last_response.status

    post_product({ name: 'Laptop' })
    assert_equal 202, last_response.status

    get "/jobs/#{response_data['job_id']}"
    assert_equal 200, last_response.status
    assert_equal 'completed', response_data['job']['status'], 'Should return completed job status'
    assert response_data['job']['errors'].empty?, 'Should return no errors'

    get '/products'
    assert_equal 200, last_response.status

    assert_equal 1, response_data['products'].size, 'Should return one product'
    assert_equal 'Laptop', response_data['products'].first['name'], 'Should return created product name'
  end
end
