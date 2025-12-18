require_relative '../test_helper'

class SessionsControllerTest < Minitest::Test
  include Rack::Test::Methods
  include TestApp
  include Support::TranslateSupport
  include Support::ResponseSupport
  include Support::RequestsSupport

  def setup
    USER_STORE.clear!

    @repo = UserRepository.new(USER_STORE)
    @user = User.new('test@example.com', 'validPassword123')

    @user.set_password!('validPassword123')
    @repo.add(@user)
  end

  def test_valid_create
    post_session({ email: @user.email, password: 'validPassword123' })
    assert_equal 201, last_response.status, 'Status must be 201'
    assert_equal @user.id, last_request.env['rack.session']['user_id'], 'Should create session with user id'
  end

  def test_delete
    post_session({ email: @user.email, password: 'validPassword123' })
    delete_session
    assert_equal 204, last_response.status, 'Status must be 204'
    assert last_request.env['rack.session'].empty?, 'Should delete session'
  end
end
