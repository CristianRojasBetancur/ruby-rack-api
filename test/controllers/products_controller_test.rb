require_relative '../test_helper'

class ProductsControllerTest < Minitest::Test
  include Rack::Test::Methods
  include TestApp
  include Support::TranslateSupport
  include Support::ResponseSupport
  include Support::RequestsSupport

  def setup
    PRODUCT_STORE.clear!

    @repo = ProductRepository.new(PRODUCT_STORE)
  end

  def test_valid_create
    api_credentials

    initial_products_count = @repo.all.count

    post_product({ name: 'Laptop' })
    assert_equal 202, last_response.status, 'Status must be 202'

    expected_message = translate_expected_message('messages.enqueued')

    assert response_data['job_id'], 'Job ID should be present'
    assert_equal expected_message, response_data['message'], 'Should be enqueued message'
    assert_equal initial_products_count + 1, @repo.all.count, 'Product should be saved'
  end

  def test_invalid_create_without_authentication
    post_product({ name: 'Laptop' })
    assert_equal 401, last_response.status, 'Status must be 401'

    expected_message = translate_expected_message('errors.unauthorized.message')

    assert_equal expected_message, response_errors[0]['message'], 'Must be invalid credentials message'
  end

  def test_invalid_index_without_authentication
    get '/products'
    assert_equal 401, last_response.status, 'Status must be 401'

    expected_message = translate_expected_message('errors.unauthorized.message')

    assert_equal expected_message, response_errors[0]['message'], 'Must be invalid credentials message'
  end

  def test_invalid_create
    api_credentials

    initial_products_count = @repo.all.count

    post_product({ name: '' })
    assert_equal 202, last_response.status, 'Status must be 202'

    expected_message = translate_expected_message('messages.enqueued')

    assert_equal expected_message, response_data['message'], 'Must be enqueued message'
    assert_equal initial_products_count, @repo.all.count, 'Product should not be saved'

    job_id = response_data['job_id']

    get_job(job_id)
    assert_equal 200, last_response.status, 'Status must be 200'

    translated_field = translate_field('product', 'name')
    expected_message = translate_expected_message('errors.blank.message', { field: translated_field })

    assert response_data['job']['errors'], 'Must exist errors'
    assert_equal expected_message, response_data['job']['errors'][0]['message'], 'Must be blank error message'
    assert_equal 'failed', response_data['job']['status'], 'Must be failed'
  end

  def test_index
    api_credentials

    %w[Laptop Monitor Keyboard].each do |name|
      product = Product.new(name)

      @repo.add(product) if product.valid?
    end

    get '/products'
    assert_equal 200, last_response.status, 'Must be 200'
    assert_equal 3, response_data['products'].size, 'Must return 3 created products'
    assert_equal %w[Laptop Monitor Keyboard], response_data['products'].map { |p| p['name'] }, 'Must be names of 3 created products'
  end

  def test_gzip_compressed_response
    api_credentials

    %w[Laptop Monitor Keyboard].each do |name|
      product = Product.new(name)

      @repo.add(product) if product.valid?
    end

    header 'Accept-Encoding', 'gzip'
    get '/products'

    assert_equal 200, last_response.status, 'Must be 200'
    assert_equal 'gzip', last_response.headers['content-encoding'], 'Should be gzip compressed'

    header 'Accept-Encoding', nil
    get '/products'
    assert_equal 200, last_response.status, 'Must be 200'
    assert_nil last_response.headers['content-encoding'], 'Should not be gzip compressed'
  end
end
