require_relative '../test_helper'

class ProductTest < Minitest::Test
  include Support::TranslateSupport

  def test_valid_product
    product = Product.new('Laptop')

    assert product.valid?
    assert_empty product.errors
  end

  def test_invalid_without_name
    product = Product.new('')
    translated_field = translate_field('product', 'name')
    expected_message = translate_expected_message('errors.blank.message', { field: translated_field })

    refute product.valid?
    assert_equal expected_message, product.errors.first[:message]
  end

  def test_invalid_with_short_name
    product = Product.new('xy')
    translated_field = translate_field('product', 'name')
    expected_message = translate_expected_message('errors.too_short.message', { field: translated_field, count: 3 })

    refute product.valid?
    assert_equal expected_message, product.errors.first[:message]
  end

  def test_invalid_with_long_name
    product = Product.new('xy' * 100)
    translated_field = translate_field('product', 'name')
    expected_message = translate_expected_message('errors.too_long.message', { field: translated_field, count: 100 })

    refute product.valid?
    assert_equal expected_message, product.errors.first[:message]
  end
end
