require_relative '../test_helper'

class UserRepositoryTest < Minitest::Test
  def setup
    USER_STORE.clear!

    @repo = UserRepository.new(USER_STORE)
  end

  def test_add_new_user
    user = User.new('user@email.com', 'validPassword123')
    @repo.add(user) if user.valid?

    found_user = @repo.find_by_email(user.email)
    assert_equal user.id, found_user.id, 'User id must exists'
  end

  def test_find_by_email
    email = 'user@email.com'
    user = User.new(email, 'validPassword123')
    @repo.add(user) if user.valid?

    found_user = @repo.find_by_email(email)

    assert found_user, 'Should find user by email'
    assert_equal email, found_user.email, 'Should find correct user'
  end
end
