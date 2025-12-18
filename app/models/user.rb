class User
  include ValidationSupport

  attr_reader :id, :email, :password, :password_digest, :errors

  def initialize(email, password)
    @id = SecureRandom.uuid
    @email = email
    @password = password
    @password_digest = nil
    @errors = []
  end

  def validate
    validate_password
    validate_email
  end

  def set_password!(password)
    @password = nil
    @password_digest = BCrypt::Password.create(password)
  end

  def authenticate_password!(password)
    BCrypt::Password.new(password_digest) == password
  end

  private

  def validate_password
    validate_field(@password.nil? || password.strip.empty?, 'errors.blank', { field: 'password' })
    validate_field(@password.length < 8, 'errors.too_short', { field: 'password', count: 8 })
    validate_field(@password.length > 100, 'errors.too_long', { field: 'password', count: 100 })
  end

  def validate_email
    validate_field(@email.nil? || email.strip.empty?, 'errors.blank', { field: 'email' })
    validate_field(!@email.match?(/^[^\s@]+@[^\s@]+\.[^\s@]+$/), 'errors.invalid', { field: 'email' })
  end
end
