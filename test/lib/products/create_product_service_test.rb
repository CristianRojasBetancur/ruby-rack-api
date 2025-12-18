require_relative '../../test_helper'

class CreateProductServiceTest < Minitest::Test
  include CustomErrors
  include Support::TranslateSupport

  def setup
    PRODUCT_STORE.clear!

    @repo = ProductRepository.new(PRODUCT_STORE)
  end

  def test_create_valid_product
    initial_products_count = @repo.all.count
    product = Products::Create.new(@repo).call({ 'name' => 'Keyboard' })

    assert product.instance_of?(Product), 'Service should return product'
    assert_equal initial_products_count + 1, @repo.all.count, 'Product should be created'
    assert_equal product, @repo.all.find { |p| p.name == product.name }, 'Product should be stored'
  end

  def test_invalid_create_without_name
    raised_exception = assert_raises ValidationError do
      Products::Create.new(@repo).call({ 'name' => '' })
    end

    expected_message = translate_expected_message('errors.blank.message', { field: translate_field('product', 'name') })

    assert_equal raised_exception.errors.first[:message], expected_message, 'Should be blank error message'
  end

  def test_invalid_create_with_short_name
    raised_exception = assert_raises ValidationError do
      Products::Create.new(@repo).call({ 'name' => 'xy' })
    end

    expected_message = translate_expected_message('errors.too_short.message', { field: translate_field('product', 'name'), count: 3 })

    assert_equal raised_exception.errors.first[:message], expected_message, 'Should be too short error message'
  end

  def test_invalid_create_with_long_name
    raised_exception = assert_raises ValidationError do
      Products::Create.new(@repo).call({ 'name' => 'xy' * 100 })
    end

    expected_message = translate_expected_message('errors.too_long.message', { field: translate_field('product', 'name'), count: 100 })

    assert_equal raised_exception.errors.first[:message], expected_message, 'Should be too long error message'
  end
end
