class Job
  STATUSES = %i[pending completed failed expired].freeze
  TTL = 3600

  attr_reader :id, :status, :errors, :object_id, :created_at

  def initialize
    @id = SecureRandom.uuid
    @status = :pending
    @errors = []
    @object_id = nil
    @created_at = Time.now
  end

  def success(object_id)
    @status = :completed
    @object_id = object_id
  end

  def failure(errors)
    @status = :failed
    @errors = errors
  end

  def expired?
    Time.now - created_at > TTL
  end

  def expire!
    @status = :expired
  end
end
