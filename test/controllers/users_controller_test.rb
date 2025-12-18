require_relative '../test_helper'

class UsersControllerTest < Minitest::Test
  include Rack::Test::Methods
  include TestApp
  include Support::TranslateSupport
  include Support::ResponseSupport
  include Support::RequestsSupport

  def setup
    USER_STORE.clear!

    @repo = UserRepository.new(USER_STORE)
  end

  def test_valid_create
    email = 'user@example.com'

    post_user({ email: email, password: 'validPassword123' })
    assert_equal 201, last_response.status, 'Status must be 201'
    assert response_data['user']['id'], 'Must return user id'
    assert_equal email, response_data['user']['email'], 'Must be sent email'

    user = @repo.find_by_email(email)

    assert user, 'User must be created'
    assert user.password_digest, 'User must have password digest'
    assert_nil user.password, 'Must not save password in store'
  end

  def test_create_with_invalid_email
    post_user({ email: 'something', password: 'validPassword123' })
    assert_equal 422, last_response.status, 'Status must be 422'

    translated_field = translate_field('user', 'email')
    expected_message = translate_expected_message('errors.invalid.message', { field: translated_field })

    assert_equal expected_message, error_response['message'], 'Must be invalid message'
  end

  def test_create_with_invalid_password
    translated_field = translate_field('user', 'password')
    expected_messages = [
      translate_expected_message('errors.too_short.message', { field: translated_field, count: 8 }),
      translate_expected_message('errors.too_long.message', { field: translated_field, count: 100 })
    ]

    ['some', 'too_long'*100].each_with_index do |invalid_password, index|
      post_user({ email: 'user@example.com', password: invalid_password })
      assert_equal 422, last_response.status, 'Status must be 422'
      assert_equal expected_messages[index], error_response['message'], 'Must be invalid message'
    end
  end

  def test_gzip_compressed_response
    header 'Accept-Encoding', 'gzip'
    post_user({ email: 'user@example.com', password: 'validPassword123' })
    assert_equal 201, last_response.status, 'Status must be 201'
    assert_equal 'gzip', last_response.headers['content-encoding'], 'Should be gzip compressed'

    header 'Accept-Encoding', nil
    post_user({ email: 'user@example.com', password: 'validPassword123' })
    assert_equal 201, last_response.status, 'Status must be 201'
    assert_nil last_response.headers['content-encoding'], 'Should not be gzip compressed'
  end
end
