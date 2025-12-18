require_relative '../test_helper'

class ProductRepositoryTest < Minitest::Test
  def setup
    PRODUCT_STORE.clear!

    @repo = ProductRepository.new(PRODUCT_STORE)
  end

  def test_add_new_product
    product = Product.new('Computadora')
    @repo.add(product) if product.valid?

    found_product = @repo.all.find { |p| p.id == product.id }
    assert_equal product.id, found_product.id, 'Product id must exists'
  end

  def test_get_all_products
    product_names = %w[Laptop Monitor Keyboard]

    product_names.map do |name|
      product = Product.new(name)
      @repo.add(product) if product.valid?
    end

    assert_equal 3, @repo.all.size, 'Products count must be same of created products'
    assert_equal product_names, @repo.all.map(&:name), 'Products names must be same of created products'
  end
end
