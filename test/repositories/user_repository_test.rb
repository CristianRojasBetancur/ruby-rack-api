require_relative '../test_helper'

class UserRepositoryTest < Minitest::Test
  def setup
    @store = MemoryStore.new
    @repo = UserRepository.new(@store)
  end

  def test_add_new_user
    user = User.new('user@email.com', 'validPassword123')
    @repo.add(user) if user.valid?

    found_user = @repo.find_by_email(user.email)
    assert_equal user.id, found_user.id, 'User id must exists'
  end

  def test_get_all_users
    product_names = %w[Laptop Monitor Keyboard]

    product_names.map do |name|
      product = Product.new(name)
      @repo.add(product) if product.valid?
    end

    assert_equal 3, @repo.all.size, 'Products count must be same of created products'
    assert_equal product_names, @repo.all.map(&:name), 'Products names must be same of created products'
  end
end
