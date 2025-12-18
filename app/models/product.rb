class Product
  include ValidationSupport

  attr_reader :id, :name, :errors

  def initialize(name)
    @id = SecureRandom.uuid
    @name = name
    @errors = []
  end

  def validate
    validate_name
  end

  private

  def validate_name
    validate_field(name.nil? || name.strip.empty?, 'errors.blank', { field: 'name' })
    validate_field(name.length < 3, 'errors.too_short', { field: 'name', count: 3 })
    validate_field(name.length > 100, 'errors.too_long', { field: 'name', count: 100 })
  end
end
