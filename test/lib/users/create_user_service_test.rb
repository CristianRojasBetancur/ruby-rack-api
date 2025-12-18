require_relative '../../test_helper'

class CreateUserServiceTest < Minitest::Test
  include CustomErrors
  include Support::TranslateSupport

  def setup
    USER_STORE.clear!

    @repo = UserRepository.new(USER_STORE)
  end

  def test_create_valid_user
    email = 'user@email.com'
    user = Users::Create.new(@repo).call({ 'email' => email, 'password' => 'validPassword123' })

    assert user.instance_of?(User), 'Service should return user'

    found_user = @repo.find_by_email(email)

    assert found_user, 'User should be created'
    assert_equal email, found_user.email, 'User should be stored'
    assert_nil found_user.password
    assert found_user.password_digest, 'Password should be hashed'
  end

  def test_invalid_create_without_email
    raised_exception = assert_raises ValidationError do
      Users::Create.new(@repo).call({ 'email' => '', 'password' => 'validPassword123' })
    end

    expected_message = translate_expected_message('errors.blank.message', { field: translate_field('user', 'email') })

    assert_equal raised_exception.errors.first[:message], expected_message, 'Should be blank error message'
    assert_nil @repo.find_by_email(''), 'User should not be created'
  end

  def test_create_with_invalid_email
    raised_exception = assert_raises ValidationError do
      Users::Create.new(@repo).call({ 'email' => 'bademail.com', 'password' => 'validPassword123' })
    end

    expected_message = translate_expected_message('errors.invalid.message', { field: translate_field('user', 'email') })

    assert_equal raised_exception.errors.first[:message], expected_message, 'Should be invalid error message'
    assert_nil @repo.find_by_email('bademail.com'), 'User should not be created'
  end

  def test_invalid_create_without_password
    raised_exception = assert_raises ValidationError do
      Users::Create.new(@repo).call({ 'email' => 'user@email.com', 'password' => '' })
    end

    expected_message = translate_expected_message('errors.blank.message', { field: translate_field('user', 'password') })

    assert_equal raised_exception.errors.first[:message], expected_message, 'Should be blank error message'
    assert_nil @repo.find_by_email('user@email.com'), 'User should not be created'
  end

  def test_invalid_create_with_short_password
    email = 'user@email.com'
    raised_exception = assert_raises ValidationError do
      Users::Create.new(@repo).call({ 'email' => email, 'password' => 'xyz' })
    end

    expected_message = translate_expected_message('errors.too_short.message', { field: translate_field('user', 'password'), count: 8 })

    assert_equal raised_exception.errors.first[:message], expected_message, 'Should be too short error message'
    assert_nil @repo.find_by_email(email), 'User should not be created'
  end

  def test_invalid_create_with_long_password
    email = 'user@email.com'
    raised_exception = assert_raises ValidationError do
      Users::Create.new(@repo).call({ 'email' => email, 'password' => 'xyz' * 100 })
    end

    expected_message = translate_expected_message('errors.too_long.message', { field: translate_field('user', 'password'), count: 100 })

    assert_equal raised_exception.errors.first[:message], expected_message, 'Should be too long error message'
    assert_nil @repo.find_by_email(email), 'User should not be created'
  end
end
