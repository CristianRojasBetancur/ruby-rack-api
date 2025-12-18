require_relative '../test_helper'

class UserTest < Minitest::Test
  include Support::TranslateSupport

  def test_valid_user
    user = User.new('user@email.com', 'validPassword123')

    assert user.valid?
    assert_empty user.errors

    user.set_password!(user.password)
    refute user.password_digest.empty?
  end

  def test_invalid_without_email
    user = User.new('', 'validPassword123')
    translated_field = translate_field('user', 'email')
    expected_message = translate_expected_message('errors.blank.message', { field: translated_field })

    refute user.valid?
    assert_equal expected_message, user.errors.first[:message]
  end

  def test_invalid_without_password
    user = User.new('user@email.com', '')
    translated_field = translate_field('user', 'password')
    expected_message = translate_expected_message('errors.blank.message', { field: translated_field })

    refute user.valid?
    assert_equal expected_message, user.errors.first[:message]
  end

  def test_invalid_with_short_password
    user = User.new('user@email.com', 'xy')
    translated_field = translate_field('user', 'password')
    expected_message = translate_expected_message('errors.too_short.message', { field: translated_field, count: 8 })

    refute user.valid?
    assert_equal expected_message, user.errors.first[:message]
  end

  def test_invalid_with_long_password
    user = User.new('user@email.com', 'xy' * 100)
    translated_field = translate_field('user', 'password')
    expected_message = translate_expected_message('errors.too_long.message', { field: translated_field, count: 100 })

    refute user.valid?
    assert_equal expected_message, user.errors.first[:message]
  end
end
